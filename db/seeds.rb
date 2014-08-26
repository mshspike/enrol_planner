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
					 {unitCode: "307554", unitName: "Science Communications 101", creditPoints: "12.5", semAvailable: "0", preUnit: "false"}])

streamunits = StreamUnit.create([{stream_id: "1", unit_id: "1"},
								 {stream_id: "2", unit_id: "1"},
								 {stream_id: "3", unit_id: "1"},
								 {stream_id: "4", unit_id: "1"},
								 {stream_id: "1", unit_id: "2"},
								 {stream_id: "2", unit_id: "2"},
								 {stream_id: "3", unit_id: "2"},
								 {stream_id: "4", unit_id: "2"},
								 {stream_id: "1", unit_id: "3"},
								 {stream_id: "2", unit_id: "3"},
								 {stream_id: "3", unit_id: "3"},
								 {stream_id: "4", unit_id: "3"},
								 {stream_id: "1", unit_id: "4"},
								 {stream_id: "2", unit_id: "4"},
								 {stream_id: "3", unit_id: "4"},
								 {stream_id: "4", unit_id: "4"},
								 {stream_id: "1", unit_id: "5"},
								 {stream_id: "2", unit_id: "5"},
								 {stream_id: "3", unit_id: "5"},
								 {stream_id: "4", unit_id: "5"},
								 {stream_id: "2", unit_id: "6"},
								 {stream_id: "1", unit_id: "7"},
								 {stream_id: "2", unit_id: "7"},
								 {stream_id: "3", unit_id: "7"},
								 {stream_id: "4", unit_id: "7"},
								 {stream_id: "3", unit_id: "8"},
								 {stream_id: "4", unit_id: "8"},
								 {stream_id: "1", unit_id: "9"},
								 {stream_id: "3", unit_id: "10"},
								 {stream_id: "1", unit_id: "11"},
								 {stream_id: "2", unit_id: "11"},
								 {stream_id: "3", unit_id: "11"},
								 {stream_id: "4", unit_id: "11"},
								 {stream_id: "4", unit_id: "12"},
								 {stream_id: "1", unit_id: "13"},
								 {stream_id: "2", unit_id: "13"},
								 {stream_id: "3", unit_id: "13"},
								 {stream_id: "4", unit_id: "13"},
								 {stream_id: "1", unit_id: "14"},
								 {stream_id: "2", unit_id: "14"},
								 {stream_id: "3", unit_id: "14"},
								 {stream_id: "4", unit_id: "14"},])

prereq = PreReq.create([{unit_id: "3", preUnit_id: "1"},
						{unit_id: "4", preUnit_id: "1"},
						{unit_id: "7", preUnit_id: "4"},
						{unit_id: "7", preUnit_id: "3"},
						{unit_id: "8", preUnit_id: "2"},
						{unit_id: "8", preUnit_id: "5"},
						{unit_id: "8", preUnit_id: "3"},
						{unit_id: "9", preUnit_id: "7"},
						{unit_id: "10", preUnit_id: "3"},
						{unit_id: "10", preUnit_id: "4"},
						{unit_id: "11", preUnit_id: "3"},
						{unit_id: "12", preUnit_id: "11"}])

user = User.new
user.email = "admin"
user.password = "admin"
user.password_confirmation = "admin"
user.save!