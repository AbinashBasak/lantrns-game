# TAVI-018 Death animation — prototype

Six separate generated poses matched to the approved Tavi model. Raw generations are unchanged in source_images. Exports use 1024 × 768 RGBA cells and pivot (512, 704). Frames are ordered standing slump, buckle, kneel, tip forward, nearly prone, final prone hold. Play once using manifest timing; the review GIF repeats.

The first four poses retain generated soft colored halos. Character scale was normalized by the blue-hair bounding box and subject alpha bounds; individual AI poses still need alignment and continuity polish. Pose 5 and 6 may be too similar. Sword/sheath detail and hand anatomy require review. Silhouette references use alpha >=230 to exclude soft halos. These are prototype assets, not production-approved animation. No runtime integration has been performed.
