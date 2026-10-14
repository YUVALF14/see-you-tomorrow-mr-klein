# See You Tomorrow, Mr. Klein — Interactive Demo

A small, self-contained playable slice of the narrative game. Mr. Klein works through several short Prague office files across two workdays. One household-record discrepancy returns the next morning; the other slips show how routine procedure continues around it.

## Play

Open index.html in a modern browser. No build step, account, or external assets are required.

1. Begin the workday.
2. Route two brief incoming office slips. Each has a Prague address and a one-step stamp action.
3. Open the main file and inspect the registry extract, rent receipt, and neighbor statement.
4. Choose whether to correct the register, uphold the archived record, or attach both accounts. Each choice opens a form action: strike through and rewrite the status, copy the official entry, or fasten the receipt to the file.
5. Copy the household street address from the request (or type it), then draw Mr. Klein's signature on the form with a mouse or finger. A typed-signature option supports keyboard use. Sign and send the copy.
6. Watch the signed copy leave the desk and return to the incoming tray the next morning. Two new short files wait beside it. The returned document, applicant's need, and evidence vary with the first decision.
7. Review the changed evidence and decide what the second office copy will record.

You can set the form aside before signing. Signing stamps the copy and sends it to the next office. Pen, punch, and stamp sounds accompany the actions; supported phones also give a brief haptic response.

The files use real public Prague addresses including Dlouhá 18, Vodičkova 681/18, Mariánské nám. 190/5, and Staroměstské náměstí 1/3; the people and case details are fictional. A compact daily docket tracks five short tasks in each workday without scoring the decisions. The browser prototype still uses generated placeholders for rain, clock, and drops. Its music bus is silent: generated music has been removed, and only a recorded, licensed performance will be added. The Godot project has distinct audio buses and named slots for recorded ambience and foley; no third-party recording has been copied into the repository yet. The rain slider adjusts the weather independently; the sound button mutes all audio. The office is fully playable without audio.

The demo has no score or correct answer. It is a prototype of the game's routine, contradictions, and unresolved residue.

## Godot development project

The first Godot 4 vertical slice is in [`godot/`](godot/). Open `godot/project.godot` with Godot 4.3 or newer. It builds a playable office scene with paper actions and hand-drawn signature input; audio import notes and researched sources are in [`godot/docs/RECORDED_AUDIO_SOURCES.md`](godot/docs/RECORDED_AUDIO_SOURCES.md).
