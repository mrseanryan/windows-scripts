/*Bundled by CustomBundler on machine NLWKS-170 at 1/10/2014 5:19:58 PM*/
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