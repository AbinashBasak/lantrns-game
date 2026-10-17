# TAVI-019 Interact with object — prototype

Six separately generated right-facing poses: ready, anticipation, reach, contact/press, retract, settle. Generated reach/press is closer to chest height than the requested waist height; match the prop to the reviewed contact position. Object remains external. Raw generations are unchanged in source_images. Exports use 1024 × 768 RGBA cells and pivot (512, 704), with head-size normalization. Play once using manifest timing. The GIF repeats for review.

AI poses need review of hand anatomy, arm length, costume continuity and foot alignment in Godot. Do not treat the contact hand as an exact prop anchor until alignment is approved. Silhouettes use alpha >=230. No runtime integration has been performed.
