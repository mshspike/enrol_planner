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

units = Unit.create([{unitCode: "10926", unitName: "Mathematics 103", creditPoints: "25", semAvailable: "1"},
					 {unitCode: "1922", unitName: "Data Structure and Algorithms 120", creditPoints: "25", semAvailable: "2"},
					 {unitCode: "7492", unitName: "Mathematics 104", creditPoints: "25", semAvailable: "1"},
					 {unitCode: "314244", unitName: "Fundamental Concepts of Cryptography 220", creditPoints: "25", semAvailable: "1"},
					 {unitCode: "4522", unitName: "Advanced Computer Coomunications 300", creditPoints: "25", semAvailable: "2"},
					 {unitCode: "314248", unitName: "Cyber Security Concepts 310", creditPoints: "25", semAvailable: "1"},
					 {unitCode: "303008", unitName: "Software Metrics 400", creditPoints: "25", semAvailable: "1"}])

streamunits = StreamUnit.create([{stream_id: "1", unit_id: "1"},
								 {stream_id: "2", unit_id: "1"},
								 {stream_id: "3", unit_id: "1"},
								 {stream_id: "4", unit_id: "1"},
								 {stream_id: "1", unit_id: "2"},
								 {stream_id: "2", unit_id: "2"},
								 {stream_id: "3", unit_id: "2"},
								 {stream_id: "4", unit_id: "2"},
								 {stream_id: "1", unit_id: "5"},
								 {stream_id: "2", unit_id: "3"},
								 {stream_id: "3", unit_id: "6"},
								 {stream_id: "4", unit_id: "7"},
								 {stream_id: "3", unit_id: "4"},
								 {stream_id: "4", unit_id: "4"}])