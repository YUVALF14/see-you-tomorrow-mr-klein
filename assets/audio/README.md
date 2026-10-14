# Browser audio slots

Place licensed recordings here using these exact names. The browser build checks for them after the player starts. Imported recordings replace the corresponding generated sound-effect fallback. Music has no generated fallback and remains silent until `music/recorded_piano.mp3` exists.

- `room/rain_window.mp3` — recorded rain, looped quietly behind the window.
- `room/clock_tick_tock.mp3` — recorded clock, looped at low volume.
- `room/ceiling_drip.mp3` — a single recorded drop; triggered at irregular intervals.
- `room/hallway_steps.mp3` — recorded footsteps, heard rarely beyond the office.
- `music/recorded_piano.mp3` — a real piano performance/room recording; very quiet, no synthetic score.
- `foley/pen_on_paper.mp3` — used during writing and corrections.
- `foley/paper_movement.mp3` — used for attachments and paper movements.
- `foley/rubber_stamp.mp3` — used for the final stamp.

For current candidate recordings and source/license notes, see [`../../godot/docs/RECORDED_AUDIO_SOURCES.md`](../../godot/docs/RECORDED_AUDIO_SOURCES.md). That document is also used by the Godot project. The repository currently has no third-party audio files; do not replace this note with an unverified download or a file whose license record was lost.
