require 'chef/formatters/base'
require 'json'

class Chef
    module Formatters
        class JsonFormat < Formatters::Base

            cli_name(:json)

            def initialize(out, err)
                super
                @steps = []
                @run_object = {
                    :resources => [],
                    :error => false,
                    :error_msg => ""
                }
            end
    
            # Called at the end of the Chef run.
            def run_completed(node)
                @run_object[:steps] = @steps
                @output.puts @run_object.to_json
            end
    
            # called at the end of a failed run
            def run_failed(exception)
                @run_object[:steps] = @steps
                @run_object[:error] = true
                @run_object[:error_msg] = exception.message
                @output.puts @run_object.to_json
            end

            # Called at the very start of a Chef Run
            def run_start(version)
                @steps << "Starting Chef Client, version #{version}"
            end
    
            # Called right after ohai runs.
            def ohai_completed(node)
                @steps << "Ohai Completed"
            end
    
            # Already have a client key, assuming this node has registered.
            def skipping_registration(node_name, config)
                @steps << "Registration Skipped"
            end
    
            # About to attempt to register as +node_name+
            def registration_start(node_name, config)
                @steps << "Registration Started"
            end
    
            def registration_completed
                @steps << "Registration Completed"
            end
    
            # Failed to register this client with the server.
            def registration_failed(node_name, exception, config)
                @steps << "Registration Failed: #{exception.message}"
            end
    
            def node_load_start(node_name, config)
                @steps << "Node data load started"
            end
    
            # Failed to load node data from the server
            def node_load_failed(node_name, exception, config)
                @steps << "Node data load failed: #{exception.message}"
            end
    
            # Default and override attrs from roles have been computed, but not yet applied.
            # Normal attrs from JSON have been added to the node.
            def node_load_completed(node, expanded_run_list, config)
                @steps << "Node data load complete"
            end
    
            # Called before the cookbook collection is fetched from the server.
            def cookbook_resolution_start(expanded_run_list)
                @steps << "Cookbook resolution started. Run list: #{expanded_run_list.join(", ")}"
            end
    
            # Called when there is an error getting the cookbook collection from the
            # server.
            def cookbook_resolution_failed(expanded_run_list, exception)
                @steps << "Cookbook resolution failed: #{exception.message}"
            end
    
            # Called when the cookbook collection is returned from the server.
            def cookbook_resolution_complete(cookbook_collection)
                @steps << "Cookbook resolution complete"
            end
    
            # Called before unneeded cookbooks are removed
            def cookbook_clean_start
                @steps << "Cookbook cleanup started"
            end
    
            # Called after the file at +path+ is removed. It may be removed if the
            # cookbook containing it was removed from the run list, or if the file was
            # removed from the cookbook.
            def removed_cookbook_file(path)
                @steps << "Cookbook #{path} removed"
            end
    
            # Called when cookbook cleaning is finished.
            def cookbook_clean_complete
                @steps << "Cookbook cleanup complete"
            end
    
            # Called before cookbook sync starts
            def cookbook_sync_start(cookbook_count)
                @steps << "Cookbook synchronize started"
            end
    
            # Called when cookbook +cookbook_name+ has been sync'd
            def synchronized_cookbook(cookbook_name)
                @steps << "Cookbook #{cookbook_name} synchronized"
            end
    
            # Called when an individual file in a cookbook has been updated
            def updated_cookbook_file(cookbook_name, path)
                @steps << "Cookbook #{cookbook_name} updated"
            end
    
            # Called after all cookbooks have been sync'd.
            def cookbook_sync_complete
                @steps << "Cookbook synchronize complete"
            end
    
            # Called when cookbook loading starts.
            def library_load_start(file_count)
                @steps << "Library loading started: #{file_count}"
            end
    
            # Called after a file in a cookbook is loaded.
            def file_loaded(path)
                @steps << "File loaded: #{path}"
            end
    
            def file_load_failed(path, exception)
                @steps << "File load failed: #{exception.message}"
            end
    
            # Called when recipes have been loaded.
            def recipe_load_complete
                @steps << "Recipe load complete"
            end
    
            # Called before convergence starts
            def converge_start(run_context)
                @steps << "Converge started: #{run_context}"
            end
    
            # Called when the converge phase is finished.
            def converge_complete
                @steps << "Converge complete"
            end
    
            def output_record(line)
                @steps << "Record output: #{line}"
            end
    
            # Called before action is executed on a resource.
            def resource_action_start(resource, action, notification_type=nil, notifier=nil)
                @steps << "Executing #{action} on #{resource}"
            end
    
            # Called when a resource fails, but will retry.
            def resource_failed_retriable(resource, action, retry_count, exception)
                @steps << "Executing #{action} on #{resource} failed retriable.  Retry count: #{retry_count} Exception: #{exception.message}"
            end
    
            # Called when a resource fails and will not be retried.
            def resource_failed(resource, action, exception)
                @steps << "Executing #{action} on #{resource} failed: #{exception.message}"
                @run_object[:resources] << {"cookbook" => "#{resource.cookbook_name}", "recipe" => "#{resource.recipe_name}", "status" => "failed"}
            end
    
            # Called when a resource action has been skipped b/c of a conditional
            def resource_skipped(resource, action, conditional)
                @steps << "Executing #{action} on #{resource} skipped"
                @run_object[:resources] << {"cookbook" => "#{resource.cookbook_name}", "recipe" => "#{resource.recipe_name}", "status" => "skipped"}
            end
    
            # Called after #load_current_resource has run.
            def resource_current_state_loaded(resource, action, current_resource)
                @steps << "Executing #{action} on #{resource} loaded #{current_resource}"
            end
    
            # Called when a resource has no converge actions, e.g., it was already correct.
            def resource_up_to_date(resource, action)
                @steps << "Executing #{action} on #{resource} was up-to-date"
                @run_object[:resources] << {"cookbook" => "#{resource.cookbook_name}", "recipe" => "#{resource.recipe_name}", "status" => "up-to-date"}
            end
    
            ## TODO: callback for assertion failures
    
            ## TODO: callback for assertion fallback in why run
    
            # Called when a change has been made to a resource. May be called multiple
            # times per resource, e.g., a file may have its content updated, and then
            # its permissions updated.
            def resource_update_applied(resource, action, update)
                @steps << "Executing #{action} on #{resource} updated: #{update}"
            end
    
            # Called after a resource has been completely converged.
            def resource_updated(resource, action)
                @steps << "Executing #{action} on #{resource} updated"
                @run_object[:resources] << {"cookbook" => "#{resource.cookbook_name}", "recipe" => "#{resource.recipe_name}", "status" => "updated"}
            end
    
            # Called before handlers run
            def handlers_start(handler_count)
                @steps << "Handlers starting.  Count #{handler_count}"
            end
    
            # Called after an individual handler has run
            def handler_executed(handler)
                @steps << "Handler #{handler} executed"
            end
    
            # Called after all handlers have executed
            def handlers_completed
                @steps << "Handlers complete"
            end

        end
    end
end