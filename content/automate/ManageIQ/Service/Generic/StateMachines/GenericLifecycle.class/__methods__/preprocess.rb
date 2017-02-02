#
# Description: This method prepares arguments and parameters for execution
module ManageIQ
  module Automate
    module Service
      module Generic
        module StateMachines
          module GenericLifecycle
            class PreProcess
              def initialize(handle = $evm)
                @handle = handle
              end

              def main
                @handle.log("info", "Starting preprocess")
                dump_root
                options = {}
                # user can insert options to override options from dialog
                service.preprocess(@handle.root["service_action"], options)
              end

              private

              def dump_root
                @handle.log("info", "Root:<$evm.root> Attributes - Begin")
                @handle.root.attributes.sort.each { |k, v| $evm.log("info", "  Attribute - #{k}: #{v}") }
                @handle.log("info", "Root:<$evm.root> Attributes - End")
                @handle.log("info", "")
              end

              def task
                @handle.root["service_template_provision_task"].tap do |task|
                  if task.nil?
                    @handle.log(:error, 'service_template_provision_task is nil')
                    raise "service_template_provision_task not found"
                  end
                end
              end

              def service
                task.destination.tap do |service|
                  if service.nil?
                    @handle.log(:error, 'Service is nil')
                    raise 'Service not found'
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  ManageIQ::Automate::Service::Generic::StateMachines::GenericLifecycle::PreProcess.new.main
end
