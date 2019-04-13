using Reproduce

const save_loc = "test_exp"
const exp_file = "examples/experiment.jl"
const exp_module_name = :Main
const exp_func_name = :main_experiment

function make_arguments(args::Dict{String, String})
    new_args = ["--opt1", args["opt1"], "--opt2", args["opt2"]]
    return new_args
end

function test_experiment()
    arg_dict = Dict(
        ["opt1"=>collect(1:50), "opt2"=>[5,6,7,8]]
    )
    arg_list = ["opt1", "opt2"]

    static_args = ["--steps", "102902"]

    args_iterator = ArgIterator(arg_dict, static_args; arg_list=arg_list, make_args=make_arguments)


    experiment = Experiment(save_loc,
                            exp_file,
                            exp_module_name,
                            exp_func_name,
                            args_iterator)

    create_experiment_dir(experiment)
    add_experiment(experiment; settings_dir="settings")
    ret = job(experiment; num_workers=6, extra_args=[save_loc])
    post_experiment(experiment, ret)

end

test_experiment()


