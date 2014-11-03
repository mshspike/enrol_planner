class Unit < ActiveRecord::Base 
    validates :unitCode, presence: { strict: true, message: 'is forgotten, click go back to import again.' }
    validates :unitName, presence: { strict: true, message: 'is forgotten, click go back to import again.' }
    validates :creditPoints, presence: { strict: true, message: 'is forgotten, click go back to import again.' }
    validates :semAvailable, presence: { strict: true, message: 'is forgotten, click go back to import again.' },
                             numericality: { only_integer: true },
                             inclusion: { :in => [0,1,2] }
    validates_length_of :unitName, :within => 5..100, :too_long => "Unit name is too long", :too_short => "Unit name is too short"
    validates_format_of :unitCode, :with => /\A[a-zA-Z]{4}[0-9]{4}\z/i
    validates_numericality_of :creditPoints, :greater_than_or_equal_to => 12.5, :less_than_or_equal_to => 50 
    validates :unitCode, uniqueness: { strict: true, message: 'not unique' }
    

    def self.import(file)
        @proceed = false
    
        #Validates the file type
        spreadsheet = open_spreadsheet(file)
    
        #Header of the spreadsheet is the name of the attributes
        header = spreadsheet.row(1)
        if header.eql? ["unitCode","unitName","preUnit","creditPoints","semAvailable"]
            @proceed = true
        else
            return false
        end
        
        if @proceed
            # Resetting the model to avoid duplication 
            ActiveRecord::Base.connection.execute("TRUNCATE units") 
            ActiveRecord::Base.connection.execute("TRUNCATE pre_req_groups") 
            ActiveRecord::Base.connection.execute("TRUNCATE pre_reqs")

            # Foreach => unit (grap each row from spreadsheet)
            (2..spreadsheet.last_row).each do |i|
                row = Hash[[header, spreadsheet.row(i)].transpose]
                unit = Unit.new
                unit.attributes = row.to_hash.slice(*["id", "unitCode", "unitName", "preUnit", "creditPoints", "semAvailable"])

                # Validates the data of the spreadsheet, save the data into the database if it is valid data.
                if unit.valid?
                    pr_string = unit.preUnit
                    # Assign T/F to preUnit column
                    if unit.preUnit.blank?
                        unit.preUnit = "false"
                    else
                        unit.preUnit = "true"
                    end
                    unit.save!
                    
                    # Check if the unit has pre-requisite
                    unless pr_string.blank?
                        # Splitting preUnit string into groups
                        groups = Array.new(pr_string.count("}"))
                        groups.length.times do |i|
                            groups[i] = pr_string[(pr_string.index("{")+1)..(pr_string.index("}")-1)]
                            pr_string.slice!(0, pr_string.index("}")+1)
                        end

                        # Foreach => pre-requisite group
                        groups.each do |grp|
                            pr_codes = grp.split(',')
                            pr_group = PreReqGroup.new(:unit_id => unit.id)
                            pr_group.save!

                            # Foreach => pre-requisite code
                            pr_codes.each do |prcode|
                                pre_req = PreReq.new(:pre_req_group_id => pr_group.id, :unit_id => unit.id, :preUnit_code => prcode)
                                pre_req.save!
                            end
                        end
                    end
                end # End IF (unit.valid?)
            end # End FOREACH unit
        end
        return true    # if imported successfully, return true
    end

################ START OF TASK EPW-29 ################
    def self.to_csv
        CSV.generate do |csv|
            csv << ["unitCode", "unitName", "preUnit", "creditPoints", "semAvailable"]

            # Foreach unit
            all.each do |unit|
                prereq_groups = PreReqGroup.where(:unit_id => unit.id)
                prereq_groups_string = Array.new

                # Foreach pre-req group
                prereq_groups.each do |prg|
                    prereqs = PreReq.where(:pre_req_group_id => prg.id)
                    prereqs_string = Array.new

                    # Foreach pre-req in group
                    prereqs.each do |pr|
                        prereqs_string.push(pr.preUnit_code)
                    end

                    prereq_groups_string.push("{"+prereqs_string.join(',')+"}")
                end

                row = unit.attributes.values_at(*["unitCode", "unitName", "creditPoints", "semAvailable"])
                row.insert(2, prereq_groups_string.join(','))
                csv << row
            end
        end
    end

################ END OF TASK EPW-29 ################
    
    def self.open_spreadsheet(file)
        #check the file extension to verity if it is a valid import file type.
        case File.extname(file.original_filename)
            when ".csv" then Roo::Csv.new(file.path)
            when ".xls" then Roo::Excel.new(file.path)
            when ".xlsx" then Roo::Excelx.new(file.path)
        else 
            raise "You have imported an unknown file type: #{file.original_filename}."
        end
    end 
    

    def unit_to_s
        "#{unitCode} #{unitName}"
    end

    def get_prereq_string
        prereq_groups = PreReqGroup.where(:unit_id => self.id)
        prereq_groups_string = Array.new

        # Foreach pre-req group
        prereq_groups.each do |prg|
            prereqs = PreReq.where(:pre_req_group_id => prg.id)
            prereqs_string = Array.new

            # Foreach pre-req in group
            prereqs.each do |pr|
                prereqs_string.push(pr.preUnit_code)
            end

            prereq_groups_string.push("{"+prereqs_string.join(',')+"}")
        end
        return prereq_groups_string.join(',')
    end

    has_many :stream_units, :foreign_key=> :unit_id
    has_many :streams, through: :stream_units

    has_many :pre_reqs, :foreign_key=> :unit_id
    has_many :preUnits, through: :pre_reqs

    has_many :pre_req_groups, :foreign_key=> :unit_id
    validates_uniqueness_of :unitCode
end
