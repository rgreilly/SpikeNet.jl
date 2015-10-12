

@generated function input_start!(group)
    subst = Dict()
    decls = []
    unpack_soa!(decls, subst, group, :group, :i, "")
    update_expr = replace(input_start(group), subst)
    gen_func = gen_update(decls, update_expr, :group)
    println(gen_func)
    return gen_func
end

@generated function update!(group, dt)
    subst = Dict()
    decls = []
    unpack_soa!(decls, subst, group, :group, :i, "")
    update_expr = replace(update(group), subst)
    gen_func = gen_update(decls, update_expr, :group)
    println(gen_func)
    return gen_func
end

@generated function reset!(group, dt)
    subst = Dict()
    decls = []
    unpack_soa!(decls, subst, group, :group, :i, "")
    update_expr = replace(reset(group), subst)
    gen_func = gen_update(decls, update_expr, :group)
    println(gen_func)
    return gen_func
end

@generated function set_current!{sink_var}(sink, ::Type{Val{sink_var}}, source)

    subst_source = Dict()
    subst_sink = Dict()
    decls = []

    unpack_soa!(decls, subst_source, source, :source, :i, "")
    unpack_soa!(decls, subst_sink, sink, :sink, :i, "")

    current_expr = replace(current(source), subst_source)
    sink_expr = replace(sink_var, subst_sink)
    update_expr = :($sink_expr = $current_expr)
    gen_func = gen_update(decls, update_expr, :sink)
    println(gen_func)
    return gen_func    
end

function gen_update(decls, do_expr, group)
    quote
        $(decls...)
        @simd for i in 1:length($group)
            @inbounds $do_expr
        end
    end
end

