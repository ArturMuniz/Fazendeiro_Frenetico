extends RefCounted

# Native Aseprite exports; no combat attributes.
const DATA: Dictionary = {
  "boss_gafanhoto_gigante": {
    "anticipate": {
      "durations_ms": [
        70,
        80,
        90
      ],
      "fps": 12.5,
      "frames": [
        "res://art/atores_polidos/boss_gafanhoto_gigante_anticipate_00.png",
        "res://art/atores_polidos/boss_gafanhoto_gigante_anticipate_01.png",
        "res://art/atores_polidos/boss_gafanhoto_gigante_anticipate_02.png"
      ],
      "loop": false,
      "offset": [
        0,
        -24
      ]
    },
    "idle": {
      "durations_ms": [
        240,
        180,
        260,
        180
      ],
      "fps": 4.651162790697675,
      "frames": [
        "res://art/atores_polidos/boss_gafanhoto_gigante_idle_00.png",
        "res://art/atores_polidos/boss_gafanhoto_gigante_idle_01.png",
        "res://art/atores_polidos/boss_gafanhoto_gigante_idle_02.png",
        "res://art/atores_polidos/boss_gafanhoto_gigante_idle_03.png"
      ],
      "loop": true,
      "offset": [
        0,
        -24
      ]
    },
    "jump": {
      "durations_ms": [
        70,
        90,
        100,
        140
      ],
      "fps": 10,
      "frames": [
        "res://art/atores_polidos/boss_gafanhoto_gigante_jump_00.png",
        "res://art/atores_polidos/boss_gafanhoto_gigante_jump_01.png",
        "res://art/atores_polidos/boss_gafanhoto_gigante_jump_02.png",
        "res://art/atores_polidos/boss_gafanhoto_gigante_jump_03.png"
      ],
      "loop": false,
      "offset": [
        0,
        -24
      ]
    },
    "land": {
      "durations_ms": [
        90,
        110,
        140
      ],
      "fps": 8.823529411764705,
      "frames": [
        "res://art/atores_polidos/boss_gafanhoto_gigante_land_00.png",
        "res://art/atores_polidos/boss_gafanhoto_gigante_land_01.png",
        "res://art/atores_polidos/boss_gafanhoto_gigante_land_02.png"
      ],
      "loop": false,
      "offset": [
        0,
        -24
      ]
    }
  },
  "boss_lagarta": {
    "idle": {
      "durations_ms": [
        280,
        160,
        220,
        340
      ],
      "fps": 4,
      "frames": [
        "res://art/atores_polidos/boss_lagarta_idle_00.png",
        "res://art/atores_polidos/boss_lagarta_idle_01.png",
        "res://art/atores_polidos/boss_lagarta_idle_02.png",
        "res://art/atores_polidos/boss_lagarta_idle_03.png"
      ],
      "loop": true,
      "offset": [
        0,
        -24
      ]
    },
    "walk": {
      "durations_ms": [
        130,
        100,
        100,
        120,
        130,
        100,
        100,
        120
      ],
      "fps": 8.88888888888889,
      "frames": [
        "res://art/atores_polidos/boss_lagarta_walk_00.png",
        "res://art/atores_polidos/boss_lagarta_walk_01.png",
        "res://art/atores_polidos/boss_lagarta_walk_02.png",
        "res://art/atores_polidos/boss_lagarta_walk_03.png",
        "res://art/atores_polidos/boss_lagarta_walk_04.png",
        "res://art/atores_polidos/boss_lagarta_walk_05.png",
        "res://art/atores_polidos/boss_lagarta_walk_06.png",
        "res://art/atores_polidos/boss_lagarta_walk_07.png"
      ],
      "loop": true,
      "offset": [
        0,
        -24
      ]
    }
  },
  "boss_rainha_moscas": {
    "attack": {
      "durations_ms": [
        65,
        80,
        80,
        150
      ],
      "fps": 10.666666666666666,
      "frames": [
        "res://art/atores_polidos/boss_rainha_moscas_attack_00.png",
        "res://art/atores_polidos/boss_rainha_moscas_attack_01.png",
        "res://art/atores_polidos/boss_rainha_moscas_attack_02.png",
        "res://art/atores_polidos/boss_rainha_moscas_attack_03.png"
      ],
      "loop": false,
      "offset": [
        0,
        -24
      ]
    },
    "death": {
      "durations_ms": [
        70,
        90,
        120,
        180
      ],
      "fps": 8.695652173913043,
      "frames": [
        "res://art/atores_polidos/boss_rainha_moscas_death_00.png",
        "res://art/atores_polidos/boss_rainha_moscas_death_01.png",
        "res://art/atores_polidos/boss_rainha_moscas_death_02.png",
        "res://art/atores_polidos/boss_rainha_moscas_death_03.png"
      ],
      "loop": false,
      "offset": [
        0,
        -24
      ]
    },
    "idle": {
      "durations_ms": [
        100,
        70,
        90,
        80
      ],
      "fps": 11.76470588235294,
      "frames": [
        "res://art/atores_polidos/boss_rainha_moscas_idle_00.png",
        "res://art/atores_polidos/boss_rainha_moscas_idle_01.png",
        "res://art/atores_polidos/boss_rainha_moscas_idle_02.png",
        "res://art/atores_polidos/boss_rainha_moscas_idle_03.png"
      ],
      "loop": true,
      "offset": [
        0,
        -24
      ]
    },
    "walk": {
      "durations_ms": [
        80,
        60,
        70,
        80,
        60,
        70
      ],
      "fps": 14.285714285714286,
      "frames": [
        "res://art/atores_polidos/boss_rainha_moscas_walk_00.png",
        "res://art/atores_polidos/boss_rainha_moscas_walk_01.png",
        "res://art/atores_polidos/boss_rainha_moscas_walk_02.png",
        "res://art/atores_polidos/boss_rainha_moscas_walk_03.png",
        "res://art/atores_polidos/boss_rainha_moscas_walk_04.png",
        "res://art/atores_polidos/boss_rainha_moscas_walk_05.png"
      ],
      "loop": true,
      "offset": [
        0,
        -24
      ]
    }
  },
  "gafanhoto": {
    "anticipate": {
      "durations_ms": [
        60,
        60,
        80
      ],
      "fps": 15,
      "frames": [
        "res://art/atores_polidos/gafanhoto_anticipate_00.png",
        "res://art/atores_polidos/gafanhoto_anticipate_01.png",
        "res://art/atores_polidos/gafanhoto_anticipate_02.png"
      ],
      "loop": false,
      "offset": [
        0,
        -16
      ]
    },
    "death": {
      "durations_ms": [
        65,
        85,
        110,
        160
      ],
      "fps": 9.523809523809524,
      "frames": [
        "res://art/atores_polidos/gafanhoto_death_00.png",
        "res://art/atores_polidos/gafanhoto_death_01.png",
        "res://art/atores_polidos/gafanhoto_death_02.png",
        "res://art/atores_polidos/gafanhoto_death_03.png"
      ],
      "loop": false,
      "offset": [
        0,
        -16
      ]
    },
    "idle": {
      "durations_ms": [
        280,
        160,
        220,
        340
      ],
      "fps": 4,
      "frames": [
        "res://art/atores_polidos/gafanhoto_idle_00.png",
        "res://art/atores_polidos/gafanhoto_idle_01.png",
        "res://art/atores_polidos/gafanhoto_idle_02.png",
        "res://art/atores_polidos/gafanhoto_idle_03.png"
      ],
      "loop": true,
      "offset": [
        0,
        -16
      ]
    },
    "jump": {
      "durations_ms": [
        75,
        85,
        85,
        105
      ],
      "fps": 11.428571428571429,
      "frames": [
        "res://art/atores_polidos/gafanhoto_jump_00.png",
        "res://art/atores_polidos/gafanhoto_jump_01.png",
        "res://art/atores_polidos/gafanhoto_jump_02.png",
        "res://art/atores_polidos/gafanhoto_jump_03.png"
      ],
      "loop": false,
      "offset": [
        0,
        -16
      ]
    },
    "land": {
      "durations_ms": [
        70,
        70,
        100
      ],
      "fps": 12.5,
      "frames": [
        "res://art/atores_polidos/gafanhoto_land_00.png",
        "res://art/atores_polidos/gafanhoto_land_01.png",
        "res://art/atores_polidos/gafanhoto_land_02.png"
      ],
      "loop": false,
      "offset": [
        0,
        -16
      ]
    }
  },
  "lesma": {
    "idle": {
      "durations_ms": [
        280,
        160,
        220,
        340
      ],
      "fps": 4,
      "frames": [
        "res://art/atores_polidos/lesma_idle_00.png",
        "res://art/atores_polidos/lesma_idle_01.png",
        "res://art/atores_polidos/lesma_idle_02.png",
        "res://art/atores_polidos/lesma_idle_03.png"
      ],
      "loop": true,
      "offset": [
        0,
        -16
      ]
    },
    "walk": {
      "durations_ms": [
        150,
        110,
        130,
        150,
        110,
        130
      ],
      "fps": 7.692307692307692,
      "frames": [
        "res://art/atores_polidos/lesma_walk_00.png",
        "res://art/atores_polidos/lesma_walk_01.png",
        "res://art/atores_polidos/lesma_walk_02.png",
        "res://art/atores_polidos/lesma_walk_03.png",
        "res://art/atores_polidos/lesma_walk_04.png",
        "res://art/atores_polidos/lesma_walk_05.png"
      ],
      "loop": true,
      "offset": [
        0,
        -16
      ]
    }
  },
  "mosca": {
    "attack": {
      "durations_ms": [
        65,
        80,
        80,
        150
      ],
      "fps": 10.666666666666666,
      "frames": [
        "res://art/atores_polidos/mosca_attack_00.png",
        "res://art/atores_polidos/mosca_attack_01.png",
        "res://art/atores_polidos/mosca_attack_02.png",
        "res://art/atores_polidos/mosca_attack_03.png"
      ],
      "loop": false,
      "offset": [
        0,
        -16
      ]
    },
    "death": {
      "durations_ms": [
        70,
        90,
        120,
        180
      ],
      "fps": 8.695652173913043,
      "frames": [
        "res://art/atores_polidos/mosca_death_00.png",
        "res://art/atores_polidos/mosca_death_01.png",
        "res://art/atores_polidos/mosca_death_02.png",
        "res://art/atores_polidos/mosca_death_03.png"
      ],
      "loop": false,
      "offset": [
        0,
        -16
      ]
    },
    "idle": {
      "durations_ms": [
        100,
        70,
        90,
        80
      ],
      "fps": 11.76470588235294,
      "frames": [
        "res://art/atores_polidos/mosca_idle_00.png",
        "res://art/atores_polidos/mosca_idle_01.png",
        "res://art/atores_polidos/mosca_idle_02.png",
        "res://art/atores_polidos/mosca_idle_03.png"
      ],
      "loop": true,
      "offset": [
        0,
        -16
      ]
    },
    "walk": {
      "durations_ms": [
        80,
        60,
        70,
        80,
        60,
        70
      ],
      "fps": 14.285714285714286,
      "frames": [
        "res://art/atores_polidos/mosca_walk_00.png",
        "res://art/atores_polidos/mosca_walk_01.png",
        "res://art/atores_polidos/mosca_walk_02.png",
        "res://art/atores_polidos/mosca_walk_03.png",
        "res://art/atores_polidos/mosca_walk_04.png",
        "res://art/atores_polidos/mosca_walk_05.png"
      ],
      "loop": true,
      "offset": [
        0,
        -16
      ]
    }
  },
  "netinho": {
    "death": {
      "durations_ms": [
        130,
        180,
        220,
        360
      ],
      "fps": 4.49438202247191,
      "frames": [
        "res://art/atores_polidos/netinho_death_00.png",
        "res://art/atores_polidos/netinho_death_01.png",
        "res://art/atores_polidos/netinho_death_02.png",
        "res://art/atores_polidos/netinho_death_03.png"
      ],
      "loop": false,
      "offset": [
        0,
        -32
      ]
    },
    "idle": {
      "durations_ms": [
        320,
        180,
        220,
        480
      ],
      "fps": 3.3333333333333335,
      "frames": [
        "res://art/atores_polidos/netinho_idle_00.png",
        "res://art/atores_polidos/netinho_idle_01.png",
        "res://art/atores_polidos/netinho_idle_02.png",
        "res://art/atores_polidos/netinho_idle_03.png"
      ],
      "loop": true,
      "offset": [
        0,
        -32
      ]
    },
    "run": {
      "durations_ms": [
        80,
        65,
        60,
        65,
        80,
        65,
        60,
        65
      ],
      "fps": 14.814814814814813,
      "frames": [
        "res://art/atores_polidos/netinho_run_00.png",
        "res://art/atores_polidos/netinho_run_01.png",
        "res://art/atores_polidos/netinho_run_02.png",
        "res://art/atores_polidos/netinho_run_03.png",
        "res://art/atores_polidos/netinho_run_04.png",
        "res://art/atores_polidos/netinho_run_05.png",
        "res://art/atores_polidos/netinho_run_06.png",
        "res://art/atores_polidos/netinho_run_07.png"
      ],
      "loop": true,
      "offset": [
        0,
        -32
      ]
    },
    "walk": {
      "durations_ms": [
        115,
        100,
        100,
        110,
        115,
        100,
        100,
        110
      ],
      "fps": 9.411764705882353,
      "frames": [
        "res://art/atores_polidos/netinho_walk_00.png",
        "res://art/atores_polidos/netinho_walk_01.png",
        "res://art/atores_polidos/netinho_walk_02.png",
        "res://art/atores_polidos/netinho_walk_03.png",
        "res://art/atores_polidos/netinho_walk_04.png",
        "res://art/atores_polidos/netinho_walk_05.png",
        "res://art/atores_polidos/netinho_walk_06.png",
        "res://art/atores_polidos/netinho_walk_07.png"
      ],
      "loop": true,
      "offset": [
        0,
        -32
      ]
    }
  },
  "pulgao": {
    "death": {
      "durations_ms": [
        70,
        90,
        110,
        160
      ],
      "fps": 9.30232558139535,
      "frames": [
        "res://art/atores_polidos/pulgao_death_00.png",
        "res://art/atores_polidos/pulgao_death_01.png",
        "res://art/atores_polidos/pulgao_death_02.png",
        "res://art/atores_polidos/pulgao_death_03.png"
      ],
      "loop": false,
      "offset": [
        0,
        -16
      ]
    },
    "idle": {
      "durations_ms": [
        280,
        160,
        220,
        340
      ],
      "fps": 4,
      "frames": [
        "res://art/atores_polidos/pulgao_idle_00.png",
        "res://art/atores_polidos/pulgao_idle_01.png",
        "res://art/atores_polidos/pulgao_idle_02.png",
        "res://art/atores_polidos/pulgao_idle_03.png"
      ],
      "loop": true,
      "offset": [
        0,
        -16
      ]
    },
    "walk": {
      "durations_ms": [
        100,
        80,
        100,
        80
      ],
      "fps": 11.11111111111111,
      "frames": [
        "res://art/atores_polidos/pulgao_walk_00.png",
        "res://art/atores_polidos/pulgao_walk_01.png",
        "res://art/atores_polidos/pulgao_walk_02.png",
        "res://art/atores_polidos/pulgao_walk_03.png"
      ],
      "loop": true,
      "offset": [
        0,
        -16
      ]
    }
  }
}
