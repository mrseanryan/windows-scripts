
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
