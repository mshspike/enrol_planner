# Helper class for Stream table
# 
# Here you can write helper methods related to Stream table. Be sure 
# when you are importing IDs, parse it to integer in case the import 
# parameter is not in integer which causes exceptions.

module StreamsHelper
    def get_stream_code sid
        return Stream.where(:id => sid.to_i).first.streamCode
    end

    def get_stream_name sid
        return Stream.where(:id => sid.to_i).first.streamName
    end
end
