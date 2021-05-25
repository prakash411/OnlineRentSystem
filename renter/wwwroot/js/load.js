$(document).ready(function () {
    l = $("#myList> div").length;
    //console.log(l);
    x = 0;
    $("#myList> div").hide();
    for (var i = 0; i < 6; i++) {
        $('#myList> div:eq(' + x + ')').show();
        //console.log("sucs->" + x);
        x++;
    }
    $('#loadMore').click(function () {
        //console.log("lm"+x);
        $("#myList> div").hide();
        for (var i = 0; i < 6; i++) {
            $('#myList> div:eq(' + x + ')').show();
            //console.log("lm->" + x);
            x++;
            //console.log("lm-->" + x);
        }
        $("#showLess").show();
        $("#loadMore").show();
        if (x - 6 < 1) {
            //console.log("<--" + x);
            $("#showLess").hide();
        }
        if (x >= l) {
            $("#loadMore").hide();
        }
    });
    $('#showLess').click(function () {
        //console.log("sl"+x);
        x -= 6;
        $("#myList> div").hide();
        if ((x - 6) >= 0) {
            x -= 6;
            for (var i = 0; i < 6; i++) {
                $('#myList> div:eq(' + x + ')').show();
                //console.log("sl->" + x);
                x++;
                //console.log("sl-->" + x);
            }
        }
        $("#showLess").show();
        $("#loadMore").show();
        if (x - 6 < 1) {
            //console.log("<--" + x);
            $("#showLess").hide();
        }
        if (x >= l) {
            $("#loadMore").hide();
        }
    });
    $("#showLess").show();
    $("#loadMore").show();
    if (x - 6 < 1) {
        //console.log("<--" + x);
        $("#showLess").hide();
    }
    if (x >= l) {
        //console.log("-->" + x);
        $("#loadMore").hide();
    }
});