$(document).ready(function() {
        $("a.showinfo").click(function() {
            var $inforow = $(this).closest("tr").next();
            if ($inforow.children().length == 0) {

                // START Ajax GET request
                $.ajax({
                    type: 'GET',
                    url: '/units/'+$(this).closest("tr").attr("id")+'.json',
                    context: this,
                    success: function(data) {

                        // START appending unit infos to "unitinfo" string
                        if (data.semAvailable===0) {
                            var sem = "Both";
                        } else {
                            var sem = data.semAvailable;
                        }var unitinfo = "<b>Semester Available:</b> " + sem +
                                       "<br /><b>Credit Points:</b> " + data.creditPoints +
                                       "<br /><b>Pre-requisites:</b> ";
                        
                        // If has pre-req, starts getting them and puts them into single string
                        if (data.preUnit==="true") {
                            var preReqString = "(";
                            for (var i=0; i<data.pre_req_groups.length; i++) {
                                var prGroup = data.pre_req_groups[i];
                                for (var j=0; j<prGroup.preUnits.length; j++) {
                                    preReqString += prGroup.preUnits[j].unitName;
                                    if (j != prGroup.preUnits.length-1) {
                                        preReqString += " AND ";
                                    }
                                }
                                preReqString += ")"
                                if (i != data.pre_req_groups.length-1) {
                                    preReqString += "<br />OR<br />";
                                }
                            }
                            unitinfo += preReqString;
                        } else {
                            unitinfo += "None";
                        }

                        // Append unitinfo string to actual HTML code
                        $(this).closest("tr").next().append("<td colspan='5' style='padding-left:3em;font-size:11px;'>"+unitinfo+"<br /><a href='#' id='checkPrereq'>Click to check Pre-requisite</a></td>");
                    }
                });
            }
            $inforow.toggle();
            return false;
        });
    });

$(document).ready(function() {
    $("a.checkPrereq").click(function() {
        alert("Hello World!");
        // Get the ID of clicked unit
        // Ajax GET request to get T/F for each of pre-req units
        // Pop-up the list of pre-req units with rather the unit is done or not
    });
});