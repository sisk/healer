require 'google_drive'

module Healer
  module Script
    class PatientBulkInput

      def initialize(key)
        @key = key
      end

      def perform
        data[1..-1].each do |row| # exclude header
          name = name_for(row)
          gender = row[1]
          birth_date = birth_date_for(row)
          case_info = case_info_for(row)
          fake_number = row[4]
        end
      end

      private ##################################################################

      def data
        @data ||= spreadsheet.worksheets[0].rows
      end

      def spreadsheet
        @spreadsheet ||= session.spreadsheet_by_key(@key)
      end

      def session
        GoogleDrive.login(username, password)
      end

      def name_for(row)
        name_parts = row[0].split(" ")
        name = { :last => name_parts.last }
        name[:first] = name_parts.first if name_parts.size > 1
        name[:middle] = middle_name_for(name_parts) if name_parts.size > 2
        name
      end

      def birth_date_for(row)
        row[2]
      end

      def middle_name_for(parts)
        (parts - [parts.first, parts.last]).join(" ")
      end

      def case_info_for(row)
        parts = row[3].split(" ")
        surgery = parts[0]

        raise "Unexpected surgery" unless surgery.size == 4
        case_sites(surgery)
      end

      def case_sites(surgery)
        toggle = surgery[0]
        procedure = surgery[1..-1]

        case procedure
        when "TKR" # Total Knee Replacement
          if toggle == "B"
            [:left_knee, :right_knee]
          elsif toggle == "R"
            [:right_knee]
          elsif toggle == "L"
            [:left_knee]
          end
        when "THR" # Total Hip Replacement
          if toggle == "B"
            [:left_hip, :right_hip]
          elsif toggle == "R"
            [:right_hip]
          elsif toggle == "L"
            [:left_hip]
          end
        else
          raise "Unexpected procedure"
        end
      end

      def username
        "jason@sisk.org"
      end

      def password
        File.exists?(pass_path) ? File.open(pass_path,"r").read.chomp : ""
      end

      def pass_path
        File.dirname(__FILE__) + "/../.pass"
      end

    end
  end
end


key = "0An56xl9DijgAdDRJcFdzbndwR2x5cGM4Q2hfTkRGQlE"
bulker = Healer::Script::PatientBulkInput.new(key)

bulker.perform