/*Bundled by CustomBundler on machine ACER7750 at 10/01/2014 19:09:10*/
/*Utilities.js*/

var Utilities = Utilities || {};

Utilities.GetMin = function (a, b) {
    return Math.min(a, b);
}

Utilities.Output = function (message, div) {
    if (!div) {
        div = 'output';
    }

    $(div).html($(div).html() + message);
}

;/*Fibonaci.js*/
/// <reference path="jquery-2.0.3.min.js" />
/// <reference path="Utilities.js" />

function FibonaciNext()
{
    return 666;
}

$(function () {
    var next = FibonaciNext();

    Utilities.Output(next);
});

;