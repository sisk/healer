#encoding: UTF-8
require File.expand_path('../../config/environment',  __FILE__)

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

      create_records(name, gender, birth_date, case_info)
    end
  end

  private ##################################################################

  def create_records(name, gender, birth_date, case_info)
    trip = Trip.next.first
    raise "No trip" unless trip
    raise "No cases" unless case_info[:sites]
    # require 'pry'; binding.pry
    patient = Patient.create!(
      :name_last => name[:last],
      :name_first => name[:first],
      :name_middle => name[:middle],
      :male => (gender == "M") ? true : false,
      :birth => birth_date
    )
    cases = []
    case_info[:sites].each do |body_part|
      side, anatomy = body_part.to_s.split("_")
      patient_case = PatientCase.create!(
        :patient => patient,
        :trip => trip,
        :body_part_id => body_part_id_for(side, anatomy)
      )
      cases << patient_case
    end

    cases.each{ |c| c.update_column(:revision,true) } if case_info[:revision]
    cases.each{ |c| c.update_column(:notes, case_info[:notes]) } if case_info[:notes]
    cases.map(&:authorize!)
    PatientCase.group_cases(cases)
  end

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
    name[:first] = name_parts.size > 1 ? name_parts.first : name_parts.last #ghaa!
    name[:middle] = middle_name_for(name_parts)
    name
  end

  def birth_date_for(row)
    age = row[2]
    return nil unless age.to_i > 0
    (Date.today - (age.to_i * 365))
  end

  def middle_name_for(parts)
    (parts - [parts.first, parts.last]).join(" ")
  end

  def case_info_for(row)
    case_info = {}

    parts = row[3].split(" ")
    surgery = parts.shift
    if parts.size > 0
      notes = parts.join(" ")
      case_info[:revision] = notes.downcase.include?("revision")
      case_info[:notes] = notes
    end

    raise "Unexpected surgery" unless surgery.size == 4
    case_info[:sites] = case_sites(surgery)
    case_info
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

  def body_part_id_for(side, anatomy)
    part = all_body_parts.select{ |bp| bp.name_en.downcase == anatomy && bp.side.downcase == side[0,1] }
    part.present? ? part.first.id : nil
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

  def all_body_parts
    @all_body_parts ||= BodyPart.all
  end

end