# Annotated Monophonic Pattern Dataset (Anonymous Release)

## Overview
This repository contains an anonymized dataset of annotated monophonic recurring musical patterns, released for peer review purposes.

The dataset consists of **40 musical pieces** drawn from **public-domain scores**. Each piece contains a varying number of annotated pattern occurrences. The annotations capture recurring melodic patterns and their transformations, with fine-grained labels designed to support music analysis and computational modeling.

This release is intended solely to support anonymous peer review. The repository will be expanded and fully documented upon acceptance.


---

## Data Sources
- All source scores are obtained from **public-domain MuseScore files**.
- Minor alterations were made to some source scores to ensure consistent formatting and correct parsing.
- For each piece, we provide:
  - The original MuseScore (`.mscz`) file
  - A corresponding exported **MusicXML** (`.mxl`) file for simplified downstream parsing

---

## Annotations
For each annotated pattern, we release the following information:

1. **MIDI excerpts** corresponding to each annotated pattern
2. **Annotation locations**, including:
   - Staff index (staff)
   - Start time (start)
   - End time  (end)
   (encoded using `music21` semantics)
3. **Raw labels (`raw_labels`)**  
   - Labels as recorded in the original annotation process
4. **Processed fine-grained labels (`labels`)**  
   - Extended and normalized labels derived from post-processing

The number of annotations varies across pieces depending on musical structure and pattern density.

---

## Label Definitions

This dataset includes two levels of labels: **raw labels** taken directly from the manual annotation process, and **processed labels** derived from systematic post-processing of the raw annotations.

### Raw Labels
Raw labels reflect the original human annotations. They describe the relationship between an annotated pattern occurrence and its reference pattern. Detailed annotation guidelines can be found in the annotation instruction documents.

#### Reference
- **REF**  
  Reference pattern for a given piece.

#### Pitch Labels
- **(No label)**
  Same intervallic relations from the reference.
- **PA** (Pitch Alteration)  
  Certain pitches differ in their intervallic relations from the reference pattern, while remaining recognizably related.
- **I** (Inversion)  
  Diatonic interval relations of the reference pattern are inverted.
- **PR** (Pitch Retrograde)  
  The order of pitch intervals is reversed.
- **NP** (No Pitch Relation)  
  No clear pitch relationship to the reference pattern.

#### Rhythm Labels
- **(No label)**
  Identical rhythm as the reference.
- **RT** (Rhythmic Transposition)  
  Proportional change in durations, such as augmentation or diminution.
- **RA** (Rhythmic Alteration)  
  Rhythmic relations differ from the reference while remaining recognizably related.
- **NR** (No Rhythm Relation)  
  No clear rhythmic relationship to the reference pattern.

#### Compound Labels
- **F** (Fragmentation)  
  Partial occurrence of the reference pattern.

---

### Processed Labels
Raw pitch and rhythm labels are further refined through post-processing to produce a set of additional **fine-grained labels** that distinguish important musical cases more precisely.

#### Processed Pitch Labels
- **SP-PT** (Same Pitch / Parallel Transposition)  
  The pattern preserves chromatic interval relations with the reference, including parallel transpositions.
- **PA-TT** (Tonal Transposition)  
  A special case of pitch alteration corresponding to tonal transposition.

#### Processed Rhythm Labels
- **SR** (Same Rhythm)  
  The pattern exhibits the same rhythmic structure as the reference.
- **RA-Off** (Rhythmic Alteration in Offset/Release)  
  Rhythmic alteration occurs in note offsets or releases, replacing the **RA** label when onset rhythms are identical.

---

### Notes
- Raw labels may include multiple pitch and rhythm labels for a single annotation.
- Processed labels are derived deterministically from the raw labels and musical structure.
- For full annotation criteria and edge cases, see the annotation instruction documents.
n.

---

## File Structure

```text
data/
├── scores/
│   └── <piece_id>/
│       ├── score.mscx        # MuseScore source file
│       └── score.mxl         # Exported MusicXML
├── annotations/
│   └── <piece_id>/
│       └── <ann_id>/
│           ├── metadata.csv  # Annotation locations and labels
│           └── midis/        # MIDI excerpts of annotated patterns
docs/
├── MuseScore-Plugins/        # Plugins used for digitization
└── Annotation-Instructions/ # Annotation and digitization guidelines
```

---

## Usage Notes
- All data in this repository is derived from public-domain musical works.
- The annotations are intended for research use in music analysis and related tasks.
- No personally identifying information is included.

---

## License
License to be finalized upon acceptance.  
This release is provided for **peer review only**.
