import QtQuick 2.0
import MuseScore 3.0

MuseScore {
      menuPath: "Plugins.Annotate"
      description: "Add parsable annotation to score: color selected notes, add an encompassing slur, and insert a staff-text box to the first note"
      version: "1.0"
      property string annoColor: "#FF0000"
      onRun: {

            
            var selection = curScore.selection;
            
            if (!isValidSelection(selection)) {
            // TODO: add pop-up for invalid selection
            
            console.log("invalid selection");

            } else {
            

            addSlur();
            var noteID = getSelectNoteId(selection);      
            console.log("note id:", noteID[0], noteID[1])
            curScore.startCmd();

            setColorForNotes(selection.elements, annoColor);
            slurColor(selection);
            curScore.endCmd();


            insertTextBox(noteID);
            
            }
            
             Qt.quit()

            }

function isValidSelection(selection) {
console.log("selection length:", filterElements(selection.elements, Element.NOTE).length);
      if (filterElements(selection.elements, Element.NOTE).length < 2) 
            return false
      return true
}            
            
function getSelectNoteId(selection) {
      var ticks = getSelectionTicks(selection);
      console.log("ticks", ticks)

      return [ticks[0], getStaffIdx(ticks[0], ticks[1])]
}
                        
       
// WORKING, extracting relative pitch and tick information from score
function extractRelativePT(selection) {
      var cursor = curScore.newCursor();
      cursor.rewind(Cursor.SELECTION_START);
}            
            
// WORKING, match with relative pitch and tick from seq
function matchNotes(relativeP, relativeT ) {
      var cursorStart = curScore.newCursor();
      cursorStart.rewind(Cursor.SCORE_START);
}                        
            
function insertTextBox(noteID) {
      curScore.selection.clear();
      var cursor = curScore.newCursor();
      cursor.staffIdx = noteID[1];
      cursor.rewindToTick(noteID[0]);

      var note = cursor.element.notes[0];
      curScore.selection.select(note, false)
       cmd("staff-text")
}       
            
function setColorForNotes(elements, color) {
    // Iterate through selected elements
      for (var i = 0; i < elements.length; i++) {
            var element = elements[i];
        // Check if the element is a note
            if (element.type == Element.NOTE) {
            // Set the color for the note
                  element.color = color;
            }
      }
}


function addSlur() {
      curScore.startCmd();
        cmd('add-slur');
        curScore.endCmd();
}

function filterElements(elements, type) {
      var n = [];
      for (var i = 0; i < elements.length; i++) {
            var element = elements[i];
            if (element.type == type) {
                  n.push(element)
            }
      }
      return n
}

// debug helper fns 
function getProperties(obj) {
      var pList = []
      for (var p in obj) {
            if (obj.hasOwnProperty(p) && obj[p] != undefined ) 
                  pList.push(p)      
      }
      return pList
}


function getSelectionTicks(selection) {
      var t0 = -1;
      var t1 = -1;
      // case no selection
      if (!selection.elements) {
            return [t0, t1]
      }
      // case sparse note selection
      if (!selection.isRange) {
            var selectedNotes = filterElements(selection.elements, Element.NOTE);
            console.log("selected notes:", selectedNotes)
            for (var i = 0; i < selectedNotes.length; i++) {
                  var note = selectedNotes[i];
                  var seg = note.parent.parent;
                  console.log("tick:", seg.tick);
                  if (t0 === -1 || t0 > seg.tick) t0 = seg.tick;
                  if (t1 === -1 || t1 < seg.tick) t1 = seg.tick;
            }
            return [t0, t1]
      }
      
      // case last bar
      if (!selection.endSegment) {
           return [t0, t1] 
      }
      
      // case range selection
      var lastTick = selection.endSegment.tick;

      console.log("last tick:", lastTick);
      var cursor = curScore.newCursor();      
      cursor.rewind(Cursor.SELECTION_START);
      var t0 = -1;
      var t1 = -1;
      var cursorState = true;
      var i = 0;
      while (cursor.tick < lastTick) {
            console.log("tick:", cursor.tick)

            if (cursor.element.type === Element.CHORD ) {
                  if (t0 === -1) t0 = cursor.tick;
                  t1 = cursor.tick
            }
            
            cursor.next()
      }       
      
      return [t0, t1]
      
}

function getStaffIdx(t0, t1) {
      console.log("retrieving staffIdx from", t0, t1);
      var cursor = curScore.newCursor();
      var endStaffIdx = curScore.nstaves;
      for (var i = 0; i < endStaffIdx; i++) {
            cursor.staffIdx = i;
            cursor.rewindToTick(t0);

            while (cursor.tick <= t1) {
                  if (cursor.element && cursor.element.type === Element.CHORD) {
                        var notes = cursor.element.notes;
                        for (var j = 0; j < notes.length; j++) {
                              var note = notes[j];
                              if (note.selected) return i
                        }
                  }
                  cursor.next();

            }
      }
      return undefined

}     

function reselectRange(tick_pos0, tick_pos1) {
      var staffId = getStaffIdx(tick_pos0, tick_pos1);
      var cursor = curScore.newCursor();
      cursor.rewindToTick(tick_pos1);
      cursor.staffIdx = staffId;
      cursor.next();
      var endTick = cursor.tick;
      console.log("select_range:",tick_pos0, tick_pos1, staffId);
      curScore.selection.clear();
      return curScore.selection.selectRange(tick_pos0, endTick, staffId, staffId+1)
}

function slurColor(selection) {
    // Iterate through selected elements
      
      var target_ticks = getSelectionTicks(selection);
      console.log("target:", target_ticks)
      if (!selection.isRange) {
          //  var prev_selection = selection.elements;
          //  if (!reselectRange(target_ticks[0], target_ticks[1])) {
          //        console.log("unable to select range")
          //        return undefined;
         //   }
               cmd("select-begin-score")
            cmd("select-end-score")

      }
      var slurs = filterElements(curScore.selection.elements, Element.SLUR);
      console.log("found slurs", slurs);
      var found = false;
      for (var i = 0; i < slurs.length; i++) {
            var slur = slurs[i];
            console.log("found slur at: ", slur.spannerTick.ticks, "-", slur.spannerTick.ticks + slur.spannerTicks.ticks)
            
            if (!found && slur.spannerTick.ticks === target_ticks[0] && slur.spannerTick.ticks + slur.spannerTicks.ticks === target_ticks[1]) {
                             // Set the color for the slur
                  console.log("colored");
                  slur.color = annoColor;
                  found = true;
            } 
 
     }
      curScore.selection.clear();
}


}



