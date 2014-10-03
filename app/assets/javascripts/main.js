// Document-ready function to listen for clicking
// "More Info" on Remaining Units section.
$(document).ready(function() {
        $("a.showinfo").click(function() {
            var $inforow = $(this).closest("tr").next();
            var $uid = $(this).closest("tr").attr("id");

            if ($inforow.children().length == 0) {
                // START Ajax GET request
                $.ajax({
                    type: 'GET',
                    url: '/units/'+$(this).closest("tr").attr("id")+'.json',
                    context: this,
                    success: function(data) {
                        // When Ajax request success, perform the following code.
                        var uid = $(this).closest("tr").attr("id");

                        // START appending unit infos to "unitinfo" string
                        if (data.semAvailable === 0) {
                            var sem = "Both";
                        } else {
                            var sem = data.semAvailable;
                        }

                        var unitinfo = "<b>Semester Available:</b> " + sem +
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
                        $(this).closest("tr").next().append("<td colspan='5' style='padding-left:3em;font-size:11px;'>"
                            + unitinfo + "<br /><a href='#' onclick='checkPrereq("
                            + uid + ");'>Click to check Pre-requisite</a></td>");
                    }
                });
            }

            // Show info row (default as hidden)
            $inforow.toggle();

            // This line is to avoid current webpage to refresh.
            return false;
        });
    });

// Function that handles user checking pre-requisites
// for the unit on Remaining units section.
function checkPrereq(uid) {
    $.ajax({
        type: 'GET',
        url: '/pre_req_checker/' + uid + '.json',   // /pre_pre_checker/1.json
        context: this,
        success: function(data) {
            if (data.has_done_all === true) {
                alert("Yes, you have done all pre-prequisite units for " + data.unitName + ".");
            } else {
                alert("You have not done all pre-requisite!");
            };
            return false;
        }
    });
}