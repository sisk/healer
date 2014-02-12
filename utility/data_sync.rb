require "highline"

module Healer
  module Utility

    class DataSync

      def replace_local_from_heroku
        dbname = local_db_name
        username = local_db_username

        create_local_dump
        system("dropdb -U #{username} --if-exists #{dbname}")
        system("createdb -O #{username} -T template0 #{dbname}")
        system("pg_restore --verbose --no-acl --no-owner -h localhost -U #{username} -d #{dbname} #{local_path}")
      end

      def back_up_to_s3
        create_local_dump
        filename = File.basename(local_path)
        s3_connection.buckets[bucket].objects["data_backup/#{filename}"].write(:file => local_path)
      end

      def push_local_to_heroku
        # back_up_to_s3
        # PGPASSWORD=mypassword pg_dump -Fc --no-acl --no-owner -h localhost -U myuser mydb > mydb.dump
      end


      private ##################################################################

      def create_local_dump
        system("heroku pgbackups:capture --expire")
        system("curl -o #{local_path} `heroku pgbackups:url`")
      end

      def local_path
        @local_path ||= "tmp/healer-#{Time.now.to_i}.pg.dump"
      end

      def bucket
        @bucket ||= Healer::S3_BUCKET
      end

      def s3_connection
        @s3_connection ||= AWS::S3.new
      end

      def local_db_username
        @local_db_username ||= if ActiveRecord::Base.connected?
          ActiveRecord::Base.connection_config[:username]
        else
          HighLine.new.ask("Local db username:") { |u| u.default = "root" }
        end
      end

      def local_db_name
        @local_db_name ||= if ActiveRecord::Base.connected?
          ActiveRecord::Base.connection_config[:database]
        else
          HighLine.new.ask("Local db:") { |u| u.default = "healer_development" }
        end
      end

    end

  end
end
