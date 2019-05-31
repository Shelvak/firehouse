// QuickButtons = (function () {
//   var
//       quickButtons
//     , alertButtons
//     , quickButtonsClasses = {
//           open   : "buttons open-buttons"
//         , closed : "buttons closed-buttons"
//     }
//     , quickButtonsState   = 'open'
//
//     , setVariables = function () {
//       quickButtons         = document.getElementById("quick-buttons")
//       alertButtons         = document.getElementById("alert-buttons")
//     }
//
//     , toggleQuickButtons = function () {
//         if (quickButtonsState == 'open' )
//           closeButtons()
//         else
//           openButtons()
//     }
//
//     , openButtons = function () {
//         quickButtonsState      = 'open'
//         quickButtons.className = quickButtonsClasses.open
//         alertButtons.className = 'alert-buttons closed'
//     }
//
//     , closeButtons = function () {
//         setVariables();
//         if ( quickButtons ) {
//           quickButtonsState      = 'closed';
//           alertButtons.className = 'alert-buttons open';
//           quickButtons.className = quickButtonsClasses.closed;
//         }
//     }
//
//     , bind = function () {
//         setVariables()
//     }
//
//   return {
//     init: bind,
//     close: closeButtons
//   }
// }());
