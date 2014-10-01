# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
streams = Stream.create([{streamCode: "314651", streamName: "Information Technology"},
                         {streamCode: "314652", streamName: "Computer Science"},
                         {streamCode: "314653", streamName: "Cyber Seurity"},
                         {streamCode: "314654", streamName: "Software Engineering"}])

units = Unit.create([{unitCode: "1920", unitName: "Object Oriented Program Design 110", creditPoints: "25", semAvailable: "0", preUnit: "false"},
                     {unitCode: "10926", unitName: "Mathematics 103", creditPoints: "25", semAvailable: "0", preUnit: "false"},
                     {unitCode: "1922", unitName: "Data Structure and Algorithms 120", creditPoints: "25", semAvailable: "0", preUnit: "true"},
                     {unitCode: "10163", unitName: "Unix and C Programming 120", creditPoints: "25", semAvailable: "2", preUnit: "true"},
                     {unitCode: "307590", unitName: "Statistical Data Analysis 101", creditPoints: "12.5", semAvailable: "0", preUnit: "false"},
                     {unitCode: "7492", unitName: "Mathematics 104", creditPoints: "25", semAvailable: "1", preUnit: "false"},
                     {unitCode: "4521", unitName: "Computer Communications 200", creditPoints: "25", semAvailable: "1", preUnit: "true"},
                     {unitCode: "314244", unitName: "Fundamental Concepts of Cryptography 220", creditPoints: "25", semAvailable: "1", preUnit: "true"},
                     {unitCode: "4522", unitName: "Advanced Computer Communications 300", creditPoints: "25", semAvailable: "2", preUnit: "true"},
                     {unitCode: "314248", unitName: "Cyber Security Concepts 310", creditPoints: "25", semAvailable: "1", preUnit: "true"},
                     {unitCode: "8934", unitName: "Software Engineering 200", creditPoints: "25", semAvailable: "2", preUnit: "true"},
                     {unitCode: "303008", unitName: "Software Metrics 400", creditPoints: "25", semAvailable: "1", preUnit: "true"},
                     {unitCode: "8933", unitName: "Software Engineering 110", creditPoints: "25", semAvailable: "1", preUnit: "false"},
                     {unitCode: "307554", unitName: "Science Communications 101", creditPoints: "12.5", semAvailable: "0", preUnit: "false"},
                     {unitCode: "300538", unitName: "Data Communications and Network Management 203", creditPoints: "25", semAvailable: "1", preUnit: "false"},
                     {unitCode: "310207", unitName: "Engineering Programming 100", creditPoints: "25", semAvailable: "0", preUnit: "false"},
                     {unitCode: "305640", unitName: "Mathematics 136", creditPoints: "25", semAvailable: "0", preUnit: "false"},
                     {unitCode: "305639", unitName: "Mathematics 135", creditPoints: "25", semAvailable: "0", preUnit: "false"}])

streamunits = StreamUnit.create([{stream_id: "1", unit_id: "1", plannedYear: "1", plannedSemester: "1"},
                                 {stream_id: "2", unit_id: "1", plannedYear: "1", plannedSemester: "1"},
                                 {stream_id: "3", unit_id: "1", plannedYear: "1", plannedSemester: "1"},
                                 {stream_id: "4", unit_id: "1", plannedYear: "1", plannedSemester: "1"},
                                 {stream_id: "1", unit_id: "2", plannedYear: "1", plannedSemester: "1"},
                                 {stream_id: "2", unit_id: "2", plannedYear: "1", plannedSemester: "1"},
                                 {stream_id: "3", unit_id: "2", plannedYear: "1", plannedSemester: "1"},
                                 {stream_id: "4", unit_id: "2", plannedYear: "1", plannedSemester: "1"},
                                 {stream_id: "1", unit_id: "3", plannedYear: "1", plannedSemester: "2"},
                                 {stream_id: "2", unit_id: "3", plannedYear: "1", plannedSemester: "2"},
                                 {stream_id: "3", unit_id: "3", plannedYear: "1", plannedSemester: "2"},
                                 {stream_id: "4", unit_id: "3", plannedYear: "1", plannedSemester: "2"},
                                 {stream_id: "1", unit_id: "4", plannedYear: "1", plannedSemester: "2"},
                                 {stream_id: "2", unit_id: "4", plannedYear: "1", plannedSemester: "2"},
                                 {stream_id: "3", unit_id: "4", plannedYear: "1", plannedSemester: "2"},
                                 {stream_id: "4", unit_id: "4", plannedYear: "1", plannedSemester: "2"},
                                 {stream_id: "1", unit_id: "5", plannedYear: "1", plannedSemester: "1"},
                                 {stream_id: "2", unit_id: "5", plannedYear: "1", plannedSemester: "1"},
                                 {stream_id: "3", unit_id: "5", plannedYear: "1", plannedSemester: "1"},
                                 {stream_id: "4", unit_id: "5", plannedYear: "1", plannedSemester: "1"},
                                 {stream_id: "2", unit_id: "6", plannedYear: "2", plannedSemester: "1"},
                                 {stream_id: "1", unit_id: "7", plannedYear: "2", plannedSemester: "1"},
                                 {stream_id: "2", unit_id: "7", plannedYear: "2", plannedSemester: "1"},
                                 {stream_id: "3", unit_id: "7", plannedYear: "2", plannedSemester: "1"},
                                 {stream_id: "4", unit_id: "7", plannedYear: "2", plannedSemester: "1"},
                                 {stream_id: "3", unit_id: "8", plannedYear: "2", plannedSemester: "1"},
                                 {stream_id: "4", unit_id: "8", plannedYear: "2", plannedSemester: "1"},
                                 {stream_id: "1", unit_id: "9", plannedYear: "2", plannedSemester: "2"},
                                 {stream_id: "3", unit_id: "10", plannedYear: "3", plannedSemester: "1"},
                                 {stream_id: "1", unit_id: "11", plannedYear: "2", plannedSemester: "2"},
                                 {stream_id: "2", unit_id: "11", plannedYear: "2", plannedSemester: "2"},
                                 {stream_id: "3", unit_id: "11", plannedYear: "2", plannedSemester: "2"},
                                 {stream_id: "4", unit_id: "11", plannedYear: "2", plannedSemester: "2"},
                                 {stream_id: "4", unit_id: "12", plannedYear: "3", plannedSemester: "1"},
                                 {stream_id: "1", unit_id: "13", plannedYear: "1", plannedSemester: "1"},
                                 {stream_id: "2", unit_id: "13", plannedYear: "1", plannedSemester: "1"},
                                 {stream_id: "3", unit_id: "13", plannedYear: "1", plannedSemester: "1"},
                                 {stream_id: "4", unit_id: "13", plannedYear: "1", plannedSemester: "1"},
                                 {stream_id: "1", unit_id: "14", plannedYear: "1", plannedSemester: "1"},
                                 {stream_id: "2", unit_id: "14", plannedYear: "1", plannedSemester: "1"},
                                 {stream_id: "3", unit_id: "14", plannedYear: "1", plannedSemester: "1"},
                                 {stream_id: "4", unit_id: "14", plannedYear: "1", plannedSemester: "1"},])

prereqgroup = PreReqGroup.create([{unit_id: "3"},
                                  {unit_id: "4"},
                                  {unit_id: "7"},
                                  {unit_id: "8"},
                                  {unit_id: "9"},
                                  {unit_id: "10"},
                                  {unit_id: "11"},
                                  {unit_id: "12"},
                                  ])

prereq = PreReq.create([{pre_req_group_id: "1", unit_id: "3", preUnit_code: "1920"},
                        {pre_req_group_id: "2", unit_id: "4", preUnit_code: "1920"},
                        {pre_req_group_id: "2", unit_id: "4", preUnit_code: "310207"},
                        {pre_req_group_id: "3", unit_id: "7", preUnit_code: "1922"},
                        {pre_req_group_id: "3", unit_id: "7", preUnit_code: "10163"},
                        {pre_req_group_id: "4", unit_id: "8", preUnit_code: "10926"},
                        {pre_req_group_id: "4", unit_id: "8", preUnit_code: "307590"},
                        {pre_req_group_id: "4", unit_id: "8", preUnit_code: "1922"},
                        {pre_req_group_id: "5", unit_id: "9", preUnit_code: "4521"},
                        {pre_req_group_id: "5", unit_id: "9", preUnit_code: "300538"},
                        {pre_req_group_id: "6", unit_id: "10", preUnit_code: "1922"},
                        {pre_req_group_id: "6", unit_id: "10", preUnit_code: "10163"},
                        {pre_req_group_id: "7", unit_id: "11", preUnit_code: "1922"},
                        {pre_req_group_id: "8", unit_id: "12", preUnit_code: "8934"}])

user = User.new
user.email = "admin"
user.password = "admin"
user.password_confirmation = "admin"
user.save!