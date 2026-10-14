# Godot development slice

This is the first Godot 4 development base for *See You Tomorrow, Mr. Klein*. The original browser build remains at the repository root while the interaction is being ported and tested.

## Run

Open `godot/project.godot` in Godot 4.3+ and press F6/F5. The current vertical slice builds its 2D office and paper UI in GDScript, so it does not require art assets to launch. No music is synthesized: the score slot stays silent until a recorded performance is imported. Audio players also stay silent until their actual recorded files exist.

## Current playable work

- A rain-lit Prague office with a procedural 2D window, desk, incoming tray, docket, and three short files.
- Mark, write, attach, set-aside, sign by hand, and stamp/send actions.
- A visible signature panel and a paper movement animation on filing.
- Audio buses for room, foley, and score, with explicit resource slots for recorded audio.
- Non-repeating drip timing and clock ticks; those sounds play from the supplied recording slots when audio files are added.

The content remains a small test slice, not the intended count or structure of the finished game. The mystery stays unresolved; the player's choices leave wording and paper traces rather than scores.

## Audio import

Put licensed Ogg Vorbis or WAV files in `audio/room`, `audio/foley`, or `audio/music`, matching the filenames in `scripts/office.gd`. Godot imports audio from project folders and routes the players through buses. See `docs/RECORDED_AUDIO_SOURCES.md` for researched recordings, license notes, and why the repository currently contains no third-party audio binaries.
