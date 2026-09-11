#!/data/data/com.termux/files/usr/bin/bash
# 3Dreaming AI — Advanced 3D Generator CLI
# No Watermark | Complex Model Edition

clear
echo "=========================================="
echo "       3Dreaming AI — ADVANCED MODE       "
echo "     Complex & Detailed 3D Generator     "
echo "=========================================="
echo ""

detect_os() {
    if [[ "$OSTYPE" == "linux-android"* ]] || grep -q "termux" /proc/version 2>/dev/null; then
        OS="android"
    elif [ "$OSTYPE" == "linux-gnu"* ]; then
        OS="linux"
    elif [ "$OSTYPE" == "darwin"* ]; then
        OS="macos"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        OS="windows"
    else
        OS="unknown"
    fi
}

check_app() {
    if [ "$OS" = "android" ]; then
        pm list packages 2>/dev/null | grep -q "com.nomadsculpt" && return 0 || return 1
    else
        command -v blender >/dev/null 2>&1 && return 0 || return 1
    fi
}

ask_permission() {
    echo "[!] 3Dreaming AI Advanced butuh akses untuk membuat model 3D kompleks."
    read -p "Izinkan lanjut? (y/n): " confirm
    [[ "$confirm" =~ ^[Yy]$ ]] && return 0 || { echo "[X] Dihentikan."; exit 1; }
}

setup_device() {
    echo "[+] Terdeteksi: $OS"
    if [ "$OS" = "android" ]; then
        if check_app; then
            echo "[✓] Nomad Sculpt sudah terpasang."
        else
            echo "[!] Membuka halaman unduh Nomad Sculpt..."
            termux-open "https://play.google.com/store/apps/details?id=com.nomadsculpt" 2>/dev/null || \
                echo "Buka: https://play.google.com/store/apps/details?id=com.nomadsculpt"
            echo "[*] Pasang dulu, lalu jalankan ulang."
            exit 0
        fi
    else
        if check_app; then
            echo "[✓] Blender sudah terpasang."
        else
            echo "[!] Memasang Blender..."
            if [ "$OS" = "linux" ]; then
                sudo apt update && sudo apt install -y blender python3-pip
            elif [ "$OS" = "macos" ]; then
                brew install --cask blender || { echo "Unduh: https://blender.org/download/macos"; exit 1; }
            elif [ "$OS" = "windows" ]; then
                echo "Unduh: https://blender.org/download/windows"
                exit 1
            fi
        fi
    fi
}

ai_login() {
    echo ""
    read -p "Ketik: 3DAI > " input
    [ "$input" = "3DAI" ] && echo "[✓] Masuk ke 3Dreaming AI ADVANCED berhasil." || { echo "[X] Salah. Gunakan: 3DAI"; exit 1; }
    echo ""
}

choose_format() {
    echo "Pilih format keluaran:"
    echo "1) .glb   ✅ Disarankan"
    echo "2) .gltf"
    echo "3) .obj"
    echo "4) .fbx"
    echo "5) .blend"
    read -p "Nomor: " fm
    case $fm in
        1) echo "glb" ;; 2) echo "gltf" ;; 3) echo "obj" ;; 4) echo "fbx" ;; 5) echo "blend" ;;
        *) echo "glb" ;;
    esac
}

generate_model() {
    local PROMPT="$1"
    local FMT="$2"
    local FILENAME="model_$(date +%Y%m%d_%H%M%S).$FMT"

    echo ""
    echo "[*] Menganalisis deskripsi..."
    echo "[*] Membuat model kompleks: $PROMPT"

    cat > /tmp/3d_adv_gen.py << 'PYEOF'
import bpy, sys, os, random, math

prompt = sys.argv[4].lower()
fmt = sys.argv[5]
outfile = sys.argv[6]

# Hapus semua objek awal
bpy.ops.object.select_all(action='SELECT')
bpy.ops.object.delete()

def add_material(obj, color_name="random", metallic=0.0, roughness=0.5):
    colors = {
        "merah": (1, 0.2, 0.2, 1), "biru": (0.2, 0.3, 1, 1), "hijau": (0.2, 1, 0.3, 1),
        "kuning": (1, 0.9, 0.2, 1), "emas": (1, 0.8, 0.1, 1), "perak": (0.9, 0.9, 0.9, 1),
        "hitam": (0.1, 0.1, 0.1, 1), "putih": (1, 1, 1, 1), "ungu": (0.7, 0.2, 1, 1),
        "oranye": (1, 0.5, 0.1, 1), "coklat": (0.5, 0.3, 0.1, 1), "hijau tua": (0.1, 0.4, 0.15, 1)
    }
    c = colors.get(color_name, (random.random(), random.random(), random.random(), 1))
    mat = bpy.data.materials.new(name="Mat")
    mat.use_nodes = True
    bsdf = mat.node_tree.nodes["Principled BSDF"]
    bsdf.inputs['Base Color'].default_value = c
    bsdf.inputs['Metallic'].default_value = metallic
    bsdf.inputs['Roughness'].default_value = roughness
    if obj.data.materials:
        obj.data.materials[0] = mat
    else:
        obj.data.materials.append(mat)

def get_color(p):
    for n in ["emas","perak","merah","biru","hijau","kuning","ungu","oranye","coklat","hitam","putih"]:
        if n in p: return n
    return "random"

def get_size(p):
    if "besar" in p: return 3
    if "kecil" in p: return 1
    return 2

S = get_size(prompt)
COLOR = get_color(prompt)
METAL = 1.0 if any(w in prompt for w in ["emas","perak","logam","besi"]) else 0.1
ROUGH = 0.1 if any(w in prompt for w in ["mengkilap","halus","berkilau"]) else 0.7

# === DETEKSI MODEL KOMPLEKS ===
obj_main = None

# Karakter / Manusia
if any(w in prompt for w in ["karakter","orang","manusia","badan","tubuh"]):
    # Badan
    bpy.ops.mesh.primitive_cube_add(size=S*0.8, location=(0,0,S*1.2))
    body = bpy.context.active_object
    body.scale = (1, 0.6, 1.2)
    add_material(body, COLOR, METAL, ROUGH)
    # Kepala
    bpy.ops.mesh.primitive_uv_sphere_add(radius=S*0.5, location=(0,0,S*2.2))
    head = bpy.context.active_object
    add_material(head, "kuning", METAL, ROUGH)
    # Mata kiri
    bpy.ops.mesh.primitive_uv_sphere_add(radius=S*0.1, location=(-0.25*S, 0.3*S, S*2.3))
    eye_l = bpy.context.active_object
    add_material(eye_l, "hitam", METAL, 0.1)
    # Mata kanan
    bpy.ops.mesh.primitive_uv_sphere_add(radius=S*0.1, location=(0.25*S, 0.3*S, S*2.3))
    eye_r = bpy.context.active_object
    add_material(eye_r, "hitam", METAL, 0.1)
    # Tangan kiri
    bpy.ops.mesh.primitive_cylinder_add(radius=S*0.12, depth=S*1.2, location=(-S, 0, S*1.3), rotation=(0, 0, 0.4))
    hand_l = bpy.context.active_object
    add_material(hand_l, COLOR, METAL, ROUGH)
    # Tangan kanan
    bpy.ops.mesh.primitive_cylinder_add(radius=S*0.12, depth=S*1.2, location=(S, 0, S*1.3), rotation=(0, 0, -0.4))
    hand_r = bpy.context.active_object
    add_material(hand_r, COLOR, METAL, ROUGH)
    # Kaki kiri
    bpy.ops.mesh.primitive_cylinder_add(radius=S*0.15, depth=S*1.3, location=(-0.35*S, 0, S*0.2))
    leg_l = bpy.context.active_object
    add_material(leg_l, "biru", METAL, ROUGH)
    # Kaki kanan
    bpy.ops.mesh.primitive_cylinder_add(radius=S*0.15, depth=S*1.3, location=(0.35*S, 0, S*0.2))
    leg_r = bpy.context.active_object
    add_material(leg_r, "biru", METAL, ROUGH)

# Rumah / Bangunan
elif any(w in prompt for w in ["rumah","bangunan","gedung"]):
    # Badan rumah
    bpy.ops.mesh.primitive_cube_add(size=S*2, location=(0,0,S))
    house = bpy.context.active_object
    house.scale = (2, 1.5, 1)
    add_material(house, "coklat", METAL, ROUGH)
    # Atap
    bpy.ops.mesh.primitive_cone_add(radius1=S*1.8, depth=S*1.2, location=(0,0,S*2.1))
    roof = bpy.context.active_object
    roof.scale = (1, 1.5, 1)
    add_material(roof, "merah", METAL, ROUGH)
    # Pintu
    bpy.ops.mesh.primitive_cube_add(size=S*0.6, location=(0, S*0.8, S*0.5))
    door = bpy.context.active_object
    door.scale = (0.4, 0.1, 1.2)
    add_material(door, "coklat", 0.0, 0.3)
    # Jendela kiri
    bpy.ops.mesh.primitive_cube_add(size=S*0.35, location=(-S*0.8, S*0.76, S*1.2))
    win1 = bpy.context.active_object
    add_material(win1, "biru", 0.9, 0.1)
    # Jendela kanan
    bpy.ops.mesh.primitive_cube_add(size=S*0.35, location=(S*0.8, S*0.76, S*1.2))
    win2 = bpy.context.active_object
    add_material(win2, "biru", 0.9, 0.1)

# Mobil / Kendaraan
elif any(w in prompt for w in ["mobil","kereta","kendaraan"]):
    # Badan mobil
    bpy.ops.mesh.primitive_cube_add(size=S, location=(0,0,S*0.6))
    car = bpy.context.active_object
    car.scale = (2.5, 1.2, 0.6)
    add_material(car, COLOR, METAL, ROUGH)
    # Kabin
    bpy.ops.mesh.primitive_cube_add(size=S*0.6, location=(S*0.3,0,S*1.1))
    cabin = bpy.context.active_object
    cabin.scale = (1.2, 1.1, 0.8)
    add_material(cabin, "biru", 0.8, 0.2)
    # Roda depan kiri
    bpy.ops.mesh.primitive_torus_add(major_radius=S*0.25, minor_radius=S*0.08, location=(S*0.8, S*0.65, S*0.25))
    w1 = bpy.context.active_object
    add_material(w1, "hitam", 0.0, 0.8)
    # Roda depan kanan
    bpy.ops.mesh.primitive_torus_add(major_radius=S*0.25, minor_radius=S*0.08, location=(S*0.8, -S*0.65, S*0.25))
    w2 = bpy.context.active_object
    add_material(w2, "hitam", 0.0, 0.8)
    # Roda belakang kiri
    bpy.ops.mesh.primitive_torus_add(major_radius=S*0.25, minor_radius=S*0.08, location=(-S*0.8, S*0.65, S*0.25))
    w3 = bpy.context.active_object
    add_material(w3, "hitam", 0.0, 0.8)
    # Roda belakang kanan
    bpy.ops.mesh.primitive_torus_add(major_radius=S*0.25, minor_radius=S*0.08, location=(-S*0.8, -S*0.65, S*0.25))
    w4 = bpy.context.active_object
    add_material(w4, "hitam", 0.0, 0.8)

# Pohon
elif any(w in prompt for w in ["pohon","tumbuhan","pucuk"]):
    # Batang
    bpy.ops.mesh.primitive_cylinder_add(radius=S*0.25, depth=S*2, location=(0,0,S))
    trunk = bpy.context.active_object
    add_material(trunk, "coklat", 0.0, 0.9)
    # Daun 1
    bpy.ops.mesh.primitive_uv_sphere_add(radius=S*0.9, location=(0,0,S*2.2))
    leaf1 = bpy.context.active_object
    leaf1.scale = (1.3, 1.3, 1)
    add_material(leaf1, "hijau", 0.0, 0.8)
    # Daun 2
    bpy.ops.mesh.primitive_uv_sphere_add(radius=S*0.65, location=(S*0.5, S*0.4, S*2.7))
    leaf2 = bpy.context.active_object
    add_material(leaf2, "hijau tua", 0.0, 0.8)
    # Daun 3
    bpy.ops.mesh.primitive_uv_sphere_add(radius=S*0.65, location=(-S*0.5, -S*0.4, S*2.7))
    leaf3 = bpy.context.active_object
    add_material(leaf3, "hijau", 0.0, 0.8)

# Robot
elif any(w in prompt for w in ["robot","mesin","mekanik"]):
    # Kepala
    bpy.ops.mesh.primitive_cube_add(size=S*0.9, location=(0,0,S*2.4))
    r_head = bpy.context.active_object
    add_material(r_head, "perak", 0.9, 0.2)
    # Mata LED
    bpy.ops.mesh.primitive_cube_add(size=S*0.15, location=(-0.25*S, S*0.46, S*2.45))
    r_eye1 = bpy.context.active_object
    add_material(r_eye1, "hijau", 1.0, 0.0)
    bpy.ops.mesh.primitive_cube_add(size=S*0.15, location=(0.25*S, S*0.46, S*2.45))
    r_eye2 = bpy.context.active_object
    add_material(r_eye2, "hijau", 1.0, 0.0)
    # Badan
    bpy.ops.mesh.primitive_cube_add(size=S*1.2, location=(0,0,S*1.3))
    r_body = bpy.context.active_object
    add_material(r_body, "perak", 0.9, 0.3)
    # Lengan kiri
    bpy.ops.mesh.primitive_cylinder_add(radius=S*0.18, depth=S*1.4, location=(-S*1.1,0,S*1.4))
    r_arm1 = bpy.context.active_object
    add_material(r_arm1, "emas", 0.9, 0.2)
    # Lengan kanan
    bpy.ops.mesh.primitive_cylinder_add(radius=S*0.18, depth=S*1.4, location=(S*1.1,0,S*1.4))
    r_arm2 = bpy.context.active_object
    add_material(r_arm2, "emas", 0.9, 0.2)
    # Kaki
    bpy.ops.mesh.primitive_cylinder_add(radius=S*0.2, depth=S*1.2, location=(-0.4*S,0,S*0.3))
    r_leg1 = bpy.context.active_object
    add_material(r_leg1, "perak", 0.9, 0.3)
    bpy.ops.mesh.primitive_cylinder_add(radius=S*0.2, depth=S*1.2, location=(0.4*S,0,S*0.3))
    r_leg2 = bpy.context.active_object
    add_material(r_leg2, "perak", 0.9, 0.3)

# Benda gabungan / Struktur
else:
    # Bentuk utama
    bpy.ops.mesh.primitive_uv_sphere_add(radius=S, location=(0,0,S))
    main = bpy.context.active_object
    add_material(main, COLOR, METAL, ROUGH)
    # Cincin luar
    bpy.ops.mesh.primitive_torus_add(major_radius=S*1.6, minor_radius=S*0.12, location=(0,0,S))
    ring1 = bpy.context.active_object
    add_material(ring1, "emas", 1.0, 0.1)
    # Cincin miring
    bpy.ops.mesh.primitive_torus_add(major_radius=S*1.3, minor_radius=S*0.09, location=(0,0,S), rotation=(math.pi/2,0,0))
    ring2 = bpy.context.active_object
    add_material(ring2, "perak", 1.0, 0.1)
    # Ornamen atas
    bpy.ops.mesh.primitive_cone_add(radius1=S*0.3, depth=S*0.8, location=(0,0,S*2))
    top = bpy.context.active_object
    add_material(top, COLOR, METAL, ROUGH)

# === SIMPAN FILE ===
if fmt == 'glb':
    bpy.ops.export_scene.gltf(filepath=outfile, export_format='GLB')
elif fmt == 'gltf':
    bpy.ops.export_scene.gltf(filepath=outfile, export_format='GLTF_EMBEDDED')
elif fmt == 'obj':
    bpy.ops.export_scene.obj(filepath=outfile)
elif fmt == 'fbx':
    bpy.ops.export_scene.fbx(filepath=outfile)
elif fmt == 'blend':
    bpy.ops.wm.save_as_mainfile(filepath=outfile)

print("[✓] BERHASIL:", outfile)
PYEOF

    if [ "$OS" != "android" ]; then
        blender --background --python /tmp/3d_adv_gen.py -- "$PROMPT" "$FMT" "$FILENAME"
        if [ -f "$FILENAME" ]; then
            echo ""
            echo "✅ SELESAI! File: $FILENAME"
            du -h "$FILENAME"
        else
            echo "[!] Gagal membuat file."
        fi
    else
        echo "[📱 Android] Buka Nomad Sculpt & buat sesuai:"
        echo "------------------------------------------"
        echo "$PROMPT"
        echo "Format: .$FMT"
        echo "Nama: $FILENAME"
        echo "------------------------------------------"
        am start -n com.nomadsculpt/.MainActivity 2>/dev/null
    fi

    rm -f /tmp/3d_adv_gen.py
}

main_loop() {
    echo "📋 Contoh perintah:"
    echo "   -> robot emas mengkilap besar"
    echo "   -> rumah merah atap coklat"
    echo "   -> mobil biru berkilau"
    echo "   -> karakter perak logam"
    echo "   -> pohon hijau besar"
    echo "   -> ketik 'exit' untuk keluar"
    echo ""
    while true; do
        read -p "3Dream> " PROMPT
        [ "$PROMPT" = "exit" ] && echo "[*] Keluar." && break
        [ -z "$PROMPT" ] && { echo "[!] Tulis deskripsinya!"; continue; }
        FMT=$(choose_format)
        generate_model "$PROMPT" "$FMT"
        echo ""
    done
}

detect_os
ask_permission
setup_device
ai_login
main_loop
