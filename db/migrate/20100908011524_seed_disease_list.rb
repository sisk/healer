class SeedDiseaseList < ActiveRecord::Migration
  
  @diseases = ["osteoarthritis (primary)","osteoarthritis (secondary)","osteonecrosis","rheumatoid arthritis","loose joint replacement","infected joint","fracture of neck of femur","dislocation of hip","congenital dislocation of hip","non union femoral neck","painful hemi arthroplasty","osteolysis/wear","frieburg infarction (osteonecrosis metatarsal head)","residual clubfoot","residual congenital vertical talus","equinous contracture","equinovarus deformity","flatfoot deformity","charcot deformity","foot drop","subtalar arthritis","bunion","hammer toe","claw toe","ankle arthritis","hindfoot arthritis","subtalar arthritis","midfoot arthritis","1st MTP arthritis","fracture nonunion"]
  
  def self.up
    Disease.destroy_all
    i = 0
    @diseases.each do |disease_name|
      i += 1
      Disease.create(:base_name => disease_name.humanize, :display_order => i)
    end
  end

  def self.down
    @diseases.each do |disease_name|
      Disease.find_by_base_name(disease_name.humanize).destroy
    end
  end
end
