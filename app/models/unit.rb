class Unit < ActiveRecord::Base 
    validates :unitCode, presence:{ strict: true, message: 'is forgotten, click go back to import again.' }
    validates :unitName, presence:{ strict: true, message: 'is forgotten, click go back to import again.'  }
    validates :creditPoints, presence:{ strict: true, message: 'is forgotten, click go back to import again.'  }
    validates :semAvailable, presence:{ strict: true, message: 'is forgotten, click go back to import again.' }
    validates_length_of :unitCode, :within => 3..10, :too_long => "Invalid Unit Code", :too_short => "Invalid Unit Code"
    validates_length_of :unitName, :within => 5..100, :too_long => "Invalid Unit Name", :too_short => "Invalid Unit Name"
    validates_numericality_of :creditPoints,  :less_than_or_equal_to => 50
    validates_numericality_of :semAvailable,  :less_than_or_equal_to => 2   
    validates :unitCode, uniqueness: { strict: true, message: 'not unique' }
    

    def self.import(file)
    
        #Validates the file type
        spreadsheet = open_spreadsheet(file)

            arr = Array.new
            # Resetting the model to avoid duplication 
            ActiveRecord::Base.connection.execute("TRUNCATE units") 
            ActiveRecord::Base.connection.execute("TRUNCATE pre_req_groups") 
            ActiveRecord::Base.connection.execute("TRUNCATE pre_reqs")
        
            #Header of the spreadsheet is the name of the attributes
            header = spreadsheet.row(1)
            
            #Import the data line by line
            (2..spreadsheet.last_row).each do |i|
                row = Hash[[header, spreadsheet.row(i)].transpose]
                    puts "hash row = " + row["id"].to_s + ": " + row.inspect
                unit = Unit.new
                    puts "new unit = " + unit.inspect
                unit.attributes = row.to_hash.slice(*["id", "unitCode", "unitName", "preUnit", "creditPoints", "semAvailable"])
                    puts "after unit = " + unit.inspect

                # Validates the data of the spreadsheet, save the data into the database if it is valid data.
                if unit.valid?
                    pre_req_string = unit.preUnit
                    puts "pre_req_String = " + pre_req_string
                    if unit.preUnit.blank?
                        unit.preUnit = "false"
                    else
                        unit.preUnit = "true"
                    end

                    # Save record to database table
                    unit.save!
                    
                    # Check if the unit has pre-requisite
                    unless pre_req_string.blank?
                        # Chopping preUnit string into groups
                        # pre_req_string = "{COMP1000,COMP1002},{COMP1000,COMP1004}"
                        groups = Array.new(pre_req_string.count("}"))
                        groups.length.times do |i|

                            groups[i] = pre_req_string[(pre_req_string.index("{")+1)..(pre_req_string.index("}")-1)]
                            
                            puts "before pre_req_string slice = " + pre_req_string
                            pre_req_string.slice!(0, pre_req_string.index("}")+1)
                            puts "after pre_req_string slice = " + pre_req_string
                        end

                        # Foreach pre-requisite group
                        groups.each do |grp|
                            # grp = "COMP1000,COMP1002"
                            puts "grp = " + grp
                            pre_req_codes = grp.split(',')

                            pr_group = PreReqGroup.new(:unit_id => unit.id)
                            pr_group.save!

                            # Foreach pre-requisite code
                            pre_req_codes.each do |prcode|
                                # prcode = "COMP1000"
                                puts "prcode = " + prcode
                                pre_req = PreReq.new(:pre_req_group_id => pr_group.id, :unit_id => unit.id, :preUnit_code => prcode)
                                pre_req.save!
                            end
                        end
                    end

                end # End IF (unit.valid?)
            end # End FOREACH row
        return true    # if imported successfully , return true
    end

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

    has_many :stream_units, :foreign_key=> :unit_id
    has_many :streams, through: :stream_units

    has_many :pre_reqs, :foreign_key=> :unit_id
    has_many :preUnits, through: :pre_reqs

    has_many :pre_req_groups, :foreign_key=> :unit_id
    validates_uniqueness_of :unitCode
end
