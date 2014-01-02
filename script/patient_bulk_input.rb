#encoding: UTF-8
require File.expand_path('../../config/environment',  __FILE__)

class PatientBulkInput

  def initialize(key)
    @key = key
  end

  def perform
    data[1..-1].each do |row| # exclude header
      name = row[0].strip
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
    patient = Patient.create!(
      :name_full => name,
      :male => (gender == "M") ? true : false,
      :birth => birth_date,
      :country => trip.country
    )
    # puts "Created patient: #{patient.name}"
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
    # puts "Authorized case IDs: #{cases.map(&:id).join(", ")}"
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

  def birth_date_for(row)
    age = row[2]
    return nil unless age.to_i > 0
    (Date.today - (age.to_i * 365))
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
    get_username_from_user
  end

  def password
    get_password_from_user
  end

  def pass_path
    File.dirname(__FILE__) + "/../.pass"
  end

  def get_username_from_user
    HighLine.new.ask("Google Docs Username:  ") { |q| q.echo = true }
  end

  def get_password_from_user
    HighLine.new.ask("Password:  ") { |q| q.echo = false }
  end

  def all_body_parts
    @all_body_parts ||= BodyPart.all
  end

end