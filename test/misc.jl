function test_labels_codes(mg::MetaGraph)
    for code in vertices(mg)
        @test code_for(mg, label_for(mg, code)) == code
    end
    for label in labels(mg)
        @test label_for(mg, code_for(mg, label)) == label
    end
    for (label_1, label_2) in edge_labels(mg)
        @test has_edge(mg, code_for(mg, label_1), code_for(mg, label_2))
    end
    for label_1 in labels(mg)
        for label_2 in outneighbor_labels(mg, label_1)
            @test has_edge(mg, code_for(mg, label_1), code_for(mg, label_2))
        end
        for label_0 in inneighbor_labels(mg, label_1)
            @test has_edge(mg, code_for(mg, label_0), code_for(mg, label_1))
        end
    end
end

@testset verbose = true "Coherence of labels and codes" begin
    graph = Graph(Edge.([(1, 2), (1, 3), (2, 3)]))
    vertices_description = [
        :red => (255, 0, 0), :green => (0, 255, 0), :blue => (0, 0, 255)
    ]
    edges_description = [
        (:red, :green) => :yellow, (:red, :blue) => :magenta, (:green, :blue) => :cyan
    ]

    colors = MetaGraph(graph, vertices_description, edges_description, "additive colors")
    test_labels_codes(colors)

    # Delete vertex in a copy and test again

    colors_copy = copy(colors)
    rem_vertex!(colors_copy, 1)
    test_labels_codes(colors)
end

@testset verbose = true "Short-form add_vertex!/add_edge!" begin
    # short-form
    mg = MetaGraph(
        Graph(); label_type=Symbol, vertex_data_type=Nothing, edge_data_type=Nothing
    )
    @test add_vertex!(mg, :A)
    @test add_vertex!(mg, :B)
    @test add_edge!(mg, :A, :B)

    # long-form
    mg2 = MetaGraph(
        Graph(); label_type=Symbol, vertex_data_type=Nothing, edge_data_type=Nothing
    )
    @test add_vertex!(mg2, :A, nothing)
    @test add_vertex!(mg2, :B, nothing)
    @test add_edge!(mg2, :A, :B, nothing)

    # compare
    @test mg == mg2
end
