This is a simple coding agent implemented in Ruby, as an experiment accompanying my blog post: ["Coding agent in 94 lines of Ruby"](https://radanskoric.com/articles/coding-agent-in-ruby).

# Usage

Whatever method you use, first copy the `.env.example` file to `.env` and add your Anthropic API key. If you want to use a different provider, modify the `run.rb` file and set the key for the other provider. Check [RubyLLM configuration documentation](https://rubyllm.com/configuration) for details.

## With docker

If you have docker the usage is really simple. Just run the `run_in_docker.sh` script.

The directory from which you run the script will be mounted into the container as `/workspace` and will be the directory in which the coding agent will operate.

## Without docker

If you're running it without docker you'll need Ruby and bundler installed.

Navigate to the root of the directory, run `bundle install`.

After that, call `ruby /path/to/run.rb` from the directory you want to operate on.

# Running tests

Execute `bundle exec rake` from the root of the project.
