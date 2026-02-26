import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

//! Hlavní třída aplikace ciferníku Home Dashboard.
class HomeDashboardApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state as Lang.Dictionary?) as Void {
    }

    function onStop(state as Lang.Dictionary?) as Void {
    }

    //! Vrací počáteční view ciferníku.
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [new HomeDashboardView()];
    }
}
