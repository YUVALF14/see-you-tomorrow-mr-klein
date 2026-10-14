# Recorded audio research and import log

The Godot scene has separate room, foley, and music buses. Source files are intentionally not copied from third-party sites until the original downloadable file and its license metadata can be saved together. Freesound's selected recordings show a CC0 license but require an account to download; the source is linked here for review.

## Candidate field recordings

| Use | Recording | License shown on source page | Import filename |
|---|---|---|---|
| Pendulum/rail-station clock, tick-tock bed | [Ticking Clock — sokworks, Freesound 860358](https://freesound.org/people/sokworks/sounds/860358/) | CC0 | `audio/room/clock_tick_tock.ogg` |
| Quiet real piano performance/room texture | [Upright Piano in Big Room — rabertfergo, Freesound 671534](https://freesound.org/people/rabertfergo/sounds/671534/) | CC0; page describes an old home piano recorded with a Zoom H1, then EQ-processed. Use as an intimate in-room musical texture, not a dramatic score. | `audio/music/recorded_piano.ogg` |
| Irregular ceiling leak / close water drop | [Water Drip — potsi, Freesound 668583](https://freesound.org/people/potsi/sounds/668583/) | CC0 | `audio/room/ceiling_drip.ogg` |
| Wet shoe steps in a hard-floored hallway | [Footsteps, wet shoes — jodybruchon, Freesound 433882](https://freesound.org/people/jodybruchon/sounds/433882/) | CC0 | `audio/room/hallway_steps.ogg` |
| Rain hitting a covered threshold, with natural drops | [rain.flac — a_l_a_r_i, Freesound 398627](https://freesound.org/people/a_l_a_r_i/sounds/398627/) | CC0, as shown in search result | `audio/room/rain_window.ogg` |

For paper, pencil/pen, rubber stamp, and a restrained low room tone, the [Sonniss GDC Game Audio Bundle](https://sonniss.com/gameaudiogdc/) is a strong production library. Sonniss's current license allows synchronized use in games and permits modification, but does not allow distributing the effects as a stand-alone sound pack; archive the version of the license that applies on download. [License text](https://sonniss.com/gdc-bundle-license/).

[Pixabay's sound-effects catalogue](https://pixabay.com/sound-effects/) is another practical source. Review the [Pixabay Content License](https://pixabay.com/service/license-summary/) per download and keep the asset page and license record with each selected file.

## License and provenance rule

Keep an `audio/sources.csv` entry for every imported recording: source page, creator, exact license, download date, original filename, edited filename, and any processing. Prefer CC0 or an explicit game-use license. Do not use CC BY-NC for a commercial-capable build; avoid BY-SA unless the share-alike implications are accepted. Do not include source audio in project exports or repositories when its license only permits project synchronization.

## Mix direction

Recorded office texture should be the foreground: rain behind glass, occasional ceiling drops, pen, paper, folder, stamp, and a distant hallway step. Keep the clock quiet and steady, not a jump-scare cue. Do not synthesize a score. The selected piano source is an actual performance/room recording; mix only a quiet excerpt or loop and keep rain and clerical foley in front. If a composed score is needed later, choose a real piano performance and verify the recording license separately from the composition rights. Avoid detective motifs, dramatic stings, and music that tells the player what to feel.
