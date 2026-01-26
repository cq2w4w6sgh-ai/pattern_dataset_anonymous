import QtQuick 2.0
import MuseScore 3.0


MuseScore {
    menuPath: "Plugins.New-Ann"
    description: "Create and saves a new, unannotated copy of the score with timestamp."
    version: "1.0"

      property string black : "#000000"
      property string annotated : "#FF0000"
      
    onRun: {
        if (!curScore) { // Check if there's an active score
            Qt.quit()
        } else {
            var filePath = curScore.path // Get the current file path
            var baseName = filePath.substring(0, filePath.lastIndexOf(".")) // Extract base name without extension
            var extension = filePath.substring(filePath.lastIndexOf(".")) // Get the file extension

            var match = /_ann(\d+)$/.exec(baseName) // Regex to find "_ann" followed by numeric suffix
            var newName, newNumber;
            if (match) {
                newName = baseName.substring(0, baseName.lastIndexOf("_ann")) // Extract name without "_annX"
                newNumber = parseInt(match[1]) + 1 // Incremented number
                newName = newName + "_ann"
            } else {
                newName = baseName + "_ann" // Add "_ann" if it's not present
                newNumber = 1 // Start numbering
            }

      // Generate a timestamp in the format of YYYYMMDD_HHMMSS
            var now = new Date();
            var timestamp = Qt.formatDateTime(now, "yyyyMMddHHmmss");

            var newFileName = newName + timestamp  + extension // Construct new file name
            console.log("new file", newFileName)            
                        // Save the new score
//            writeScore(curScore, curScore.path, 'mscz') // save the current score
            writeScore(curScore, newFileName, "mscz") // create new copy (Write current score to new file name)
            var newScore = readScore(newFileName) // open new score
            
            removeScoreAnnotation(newScore) // remove all annotations
            // save changes
            writeScore(newScore, newFileName, "mscz")
                        Qt.quit()
        
    }
    
    
function removeScoreAnnotation(score) {
      var endStaff = score.nstaves
      var endTick = curScore.lastSegment.tick + 1;
      var selectionResult = score.selection.selectRange(0, endTick, 0, endStaff)
      console.log(score.selection.elements[0])
       score.startCmd()

      score.endCmd()
      clearNoteColorsAndTags(score.selection)
      clearSlurs(score.selection)
      score.selection.clear()
}
         
    
function clearNoteColorsAndTags(selection) {
      var notes =  filterElements(selection.elements, Element.NOTE);
      for (var i = 0; i < notes.length; i++) {
            var note = notes[i];
            note.color = black
      }
      var tags = filterElements(selection.elements, Element.STAFF_TEXT);
            
            for (i = 0; i < tags.length; i++) {
            var tag = tags[i];
            removeElement(tag)
      }
      
}
      
function clearSlurs(selection) {
      var slurs = filterElements(selection.elements, Element.SLUR);
      for (var i = 0; i < slurs.length; i++)  {
            var slur= slurs[i];
            if (slur.color != black) {
            removeElement(slur)
            }
           
            
      }

}

function printElements(selection) {
      var elements = selection.elements
      for (var i = 0; i < elements.length; i++) {
            var e = elements[i];
            console.log(e.name)
      }
            
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
            
      }

}