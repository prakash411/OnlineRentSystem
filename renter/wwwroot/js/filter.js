$(".search").click(function () {

    var BHK_L = $('.BHK').val();
    var Furnishing_L = $('.Furnishing').val();
    var PropertyType_L = $('.PropertyType').val();

    for (var i = 0; i < PropertyType_L.length; i++) {
        if (!PropertyType_L[i].localeCompare("Independent Villa")) {
            PropertyType_L[i] = PropertyType_L[i].replace("Independent Villa", "Villa");
        }
        if (!PropertyType_L[i].localeCompare("Farm House")) {
            PropertyType_L[i] = PropertyType_L[i].replace("Farm House", "House");
        }
        if (!PropertyType_L[i].localeCompare("Independent Floor")) {
            PropertyType_L[i] = PropertyType_L[i].replace("Independent Floor", "Floor");
        }
    }


    //empty
    if (BHK_L.length == 0 && Furnishing_L.length == 0 && PropertyType_L.length == 0) {
        $(".filter").show('3000');
    }
    //BHK_L
    if (BHK_L.length != 0 && Furnishing_L.length == 0 && PropertyType_L.length == 0) {
        $(".filter").hide('3000');
        BHK_L.forEach(func);
        function func(value) {
            $('.filter').filter('.' + value).show('3000');
        }
    }
    //Furnishing_L
    if (BHK_L.length == 0 && Furnishing_L.length != 0 && PropertyType_L.length == 0) {
        $(".filter").hide('3000');
        Furnishing_L.forEach(func);
        function func(value) {
            $('.filter').filter('.' + value).show('3000');
        }
    }
    //PropertyType_L
    if (BHK_L.length == 0 && Furnishing_L.length == 0 && PropertyType_L.length != 0) {
        $(".filter").hide('3000');
        PropertyType_L.forEach(func);
        function func(value) {
            $('.filter').filter('.' + value).show('3000');
        }
    }
    //BHK_L Furnishing_L
    if (BHK_L.length != 0 && Furnishing_L.length != 0 && PropertyType_L.length == 0) {

        var result = [];
        for (var i = 0; i < BHK_L.length; i++) {
            for (var j = 0; j < Furnishing_L.length; j++) {
                result.push(BHK_L[i] + Furnishing_L[j])
            }
        }
        console.log(result);

        $(".filter").hide('3000');
        result.forEach(func);
        function func(value) {
            $('.filter').filter('.' + value).show('3000');
        }
    }
    //PropertyType_L Furnishing_L
    if (BHK_L.length == 0 && Furnishing_L.length != 0 && PropertyType_L.length != 0) {

        var result = [];
        for (var i = 0; i < PropertyType_L.length; i++) {
            for (var j = 0; j < Furnishing_L.length; j++) {
                result.push(PropertyType_L[i] + Furnishing_L[j])
            }
        }
        console.log(result);

        $(".filter").hide('3000');
        result.forEach(func);
        function func(value) {
            $('.filter').filter('.' + value).show('3000');
        }
    }
    //PropertyType_L BHK_L
    if (BHK_L.length != 0 && Furnishing_L.length == 0 && PropertyType_L.length != 0) {

        var result = [];
        for (var i = 0; i < PropertyType_L.length; i++) {
            for (var j = 0; j < BHK_L.length; j++) {
                result.push(PropertyType_L[i] + BHK_L[j])
            }
        }
        console.log(result);

        $(".filter").hide('3000');
        result.forEach(func);
        function func(value) {
            $('.filter').filter('.' + value).show('3000');
        }
    }
    //PropertyType_L BHK_L Furnishing_L
    if (BHK_L.length != 0 && Furnishing_L.length != 0 && PropertyType_L.length != 0) {

        var result = [];
        for (var i = 0; i < PropertyType_L.length; i++) {
            for (var j = 0; j < BHK_L.length; j++) {
                for (var k = 0; k < Furnishing_L.length; k++) {
                    result.push(PropertyType_L[i] + BHK_L[j] + Furnishing_L[k]);
                }
            }
        }
        console.log(result);

        $(".filter").hide('3000');
        result.forEach(func);
        function func(value) {
            $('.filter').filter('.' + value).show('3000');
        }
    }
});


$('#multiselect-BHK').multiselect({
    includeSelectAllOption: true,
    nonSelectedText: 'select BHK'
});
$('#multiselect-Furnishing').multiselect({
    includeSelectAllOption: true,
    nonSelectedText: 'select Furnishing'
});
$('#multiselect-PropertyType').multiselect({
    includeSelectAllOption: true,
    nonSelectedText: 'select PropertyType'
});