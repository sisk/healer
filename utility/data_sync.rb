module Healer
  module Utility

    class DataSync

      def replace_local_from_heroku
        create_local_dump
        system("pg_restore --verbose --clean --no-acl --no-owner -h localhost -U #{local_db_username} -d #{local_db_name} #{local_path}")
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
        ActiveRecord::Base.connection_config[:username]
      end

      def local_db_name
        ActiveRecord::Base.connection_config[:database]
      end
    end

  end
end
