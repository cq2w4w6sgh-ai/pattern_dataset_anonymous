import QtQuick 2.0
import MuseScore 3.0

MuseScore {
      menuPath: "Plugins.Clear-Ann"
      description: "Removing annotation in the selected region"
      version: "1.0"
      
      property string black : "#000000"
      property string annotated : "#FF0000"

      onRun: {
            var selection = curScore.selection;
            
            clearNoteColorsAndTags(selection);
            clearSlurs(selection);
            
            Qt.quit()
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
