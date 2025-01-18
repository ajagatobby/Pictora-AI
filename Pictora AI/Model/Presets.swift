import Foundation


struct Preset {
    let id = UUID().uuidString
    let name: String
    let imageUrl: String
}


let presets: [Preset] = [
    Preset(name: "Cinematic", imageUrl: "https://image.lexica.art/full_webp/2d42eefe-c11d-4282-b211-9a9df54f81fb"),
    Preset(name: "Redhood", imageUrl: "https://image.lexica.art/full_webp/18f864d3-5cb8-416f-b236-cb55b93dfd4c"),
    Preset(name: "Color paint", imageUrl: "https://image.lexica.art/full_webp/3295b0d8-7aa6-47fe-a21f-1692a349116b"),
    Preset(name: "Mosaic", imageUrl: "https://image.lexica.art/full_webp/3b05cdb1-4265-438e-8230-8a35428fe210"),
    Preset(name: "Nature", imageUrl: "https://image.lexica.art/full_webp/1c714815-51df-45a6-95ea-6ff9743e98d4"),
    Preset(name: "3D Art", imageUrl: "https://image.lexica.art/full_webp/8ee95aa8-1c57-45b7-b027-ae7285879709"),
    Preset(name: "Statue", imageUrl: "https://image.lexica.art/full_webp/a7139f15-bcfc-4176-834b-56f3e0ec3c6e"),
    Preset(name: "Action Fig", imageUrl: "https://image.lexica.art/full_webp/90aba3c6-77d9-43f0-8ffa-6bc9fe9e57b9")
]


let signaturePresets: [Preset] = [
    Preset(name: "Business Classic", imageUrl: "business-classic"),
    Preset(name: "Elegant Script", imageUrl: "elegant-script"),
    Preset(name: "Modern Professional", imageUrl: "modern-professional"),
    Preset(name: "Creative Artistic", imageUrl: "creative-artistic"),
    Preset(name: "Legal Style", imageUrl: "legal-style"),
    Preset(name: "Minimalist", imageUrl: "minimalistic"),
    Preset(name: "Calligraphy", imageUrl: "calligraphic")
]
