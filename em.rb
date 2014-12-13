require 'redis'
require 'eventmachine'
require 'pry-nav'


$clients = []

module Semaforo
  @@active_ids = []

  def post_init
    p "Se conecto"
    $clients << self
  end

  def receive_data(data)
    p "Recibi: #{data}"

    case
      when id = match_keep_alive(data)
        id_included_in_active_devices?(id[1]) ? send_ok : send_reconnect

      when matchs = match_presentation(data)
        add_id_to_active_devices! @id = matchs[2]
        send_ok

      when data.match(/ALSOK/) then nil

      else
        say_hi
    end
  end

  def unbind
    $clients.delete(self)
    remove_id_from_active_devices!(@id)
  end

  module EventListener

    class << self
      def subscribe
        redis.subscribe('semaforo') do |on|
          on.message do |channel, msg|
            opts = JSON.parse(msg).symbolize_keys
            p "Redis: #{opts}"
            send_welf_to_all(opts)
          end
        end
      end

      private

        def redis
          @redis ||= Redis.new
        end

        def send_welf_to_all(msg)
          $clients.each { |client| client.send_data welf(msg) }
        end

        def welf(opts)
          [
            62, 65, 76, 83,
            0, # prioridad
            0, # dotacion
            0, # movil
            (opts[:red]    ? 1 : 0),
            (opts[:green]  ? 1 : 0),
            (opts[:yellow] ? 1 : 0),
            (opts[:blue]   ? 1 : 0),
            (opts[:white]  ? 1 : 0),
            (opts[:trap]   ? 1 : 0),
            (opts[:day]    ? 1 : 0),
            (opts[:sleep]  ? 1 : 0),
            60
          ].map(&:chr).join
        end
    end
  end

  private

    def match_keep_alive(data)
      data.match(keep_alive_regex)
    end

    def match_presentation(data)
      data.match(presentation_regex)
    end

    def presentation_regex
      />#SEMAFORO\[V(\d+\.\d+.\d+)\]-\((\d{3})\)/
    end

    def keep_alive_regex
      />S\((\d+)\)</
    end

    def say_hi
      p "Say Hi"
      send_data ">$?<"
    end

    def send_ok
      p "Ok"
      send_data ">SOK<"
    end

    def send_reconnect
      say_hi
    end

    def add_id_to_active_devices!(id)
      puts "Adding #{id}:Device"
      @@active_ids << id
    end

    def remove_id_from_active_devices!(id)
      puts "Dropping #{id}:Device"
      @@active_ids.delete(id)
    end

    def id_included_in_active_devices?(id)
      @@active_ids.include?(id)
    end

    def send_unknown_device
      send_data "Unkown"
      close_connection
    end
end



Thread.new { EventMachine.run { EventMachine.start_server('0.0.0.0', 9800, Semaforo) } }

Thread.new { Semaforo::EventListener.subscribe }




