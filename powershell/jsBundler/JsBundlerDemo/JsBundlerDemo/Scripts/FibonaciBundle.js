/*bundled by JsBundler at 12/05/2013 17:03:45 on NLWKS-170 */
/*JsBundlerDemo/Scripts/Utilities.js*/

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
;
/*JsBundlerDemo/Scripts/Fibonaci.js*/
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
