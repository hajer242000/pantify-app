// // 🌸 Flowering Plants
// import 'package:plant_app/models/plant_model.dart';

// final List<PlantModel> floweringPlants = [
//   PlantModel(
//     name: "Rose",
//     description:
//         "Roses are among the most iconic flowering plants, admired for their elegance, wide range of colors, and sweet fragrance. They symbolize love, passion, and beauty, and are widely cultivated in gardens and used in floral arrangements for special occasions.",
//     category: "Flowering",
//     season: "Spring",
//     country: "Netherlands",
//     price: 5.0,
//     discount: 4.5,
//     quantity: 100,
//     image:
//         "https://cdn.pixabay.com/photo/2015/03/26/18/11/rose-693155_1280.jpg",
//   ),
//   PlantModel(
//     name: "Tulip",
//     description:
//         "Tulips are vibrant spring-blooming flowers known for their cup-shaped blossoms and variety of striking colors. Originally from Turkey, they gained immense popularity in the Netherlands, where they are celebrated during tulip festivals.",
//     category: "Flowering",
//     season: "Spring",
//     country: "Turkey",
//     price: 3.0,
//     quantity: 80,
//     image:
//         "https://cdn.pixabay.com/photo/2020/03/18/19/52/wild-tulip-4945396_1280.jpg",
//   ),
//   PlantModel(
//     name: "Orchid",
//     description:
//         "Orchids are exotic and elegant plants with long-lasting flowers. They are admired for their unique petal shapes and vibrant colors, symbolizing luxury, refinement, and delicate beauty. They thrive indoors with proper care of light and humidity.",
//     category: "Flowering",
//     season: "All Year",
//     country: "Thailand",
//     price: 15.0,
//     discount: 12.0,
//     quantity: 50,
//     image:
//         "https://cdn.pixabay.com/photo/2020/07/10/15/26/orchids-5391012_1280.jpg",
//   ),
//   PlantModel(
//     name: "Lavender",
//     description:
//         "Lavender is a fragrant purple-flowered herb widely valued for its calming aroma and beautiful fields of blooms. It is commonly used in essential oils, soaps, and teas, and symbolizes tranquility and healing.",
//     category: "Flowering",
//     season: "Summer",
//     country: "France",
//     price: 4.0,
//     quantity: 60,
//     image:
//         "https://cdn.pixabay.com/photo/2016/12/07/10/13/lavender-1889141_1280.jpg",
//   ),
//   PlantModel(
//     name: "Jasmine",
//     description:
//         "Jasmine is a flowering plant famous for its intoxicating fragrance and delicate white blossoms. It is often associated with love, purity, and spirituality, and widely used in perfumes and teas.",
//     category: "Flowering",
//     season: "Summer",
//     country: "Oman",
//     price: 6.0,
//     quantity: 70,
//     image:
//         "https://cdn.pixabay.com/photo/2020/06/06/15/48/scent-of-jasmine-5267074_1280.jpg",
//   ),
// ];

// // 🌿 Herbs
// final List<PlantModel> herbs = [
//   PlantModel(
//     name: "Basil",
//     description:
//         "Basil is a fragrant herb commonly used in Italian, Mediterranean, and Asian cuisines. Its bright green leaves are rich in essential oils that enhance the flavor of sauces, salads, and soups. It symbolizes freshness and good health.",
//     category: "Herb",
//     season: "Summer",
//     country: "India",
//     price: 1.5,
//     quantity: 90,
//     image: "https://cdn.pixabay.com/photo/2015/09/09/17/38/basil-932079_1280.jpg",
//   ),
//   PlantModel(
//     name: "Mint",
//     description:
//         "Mint is a refreshing and aromatic herb with cooling properties. It is widely used in teas, beverages, desserts, and traditional remedies for digestion. Mint grows quickly in moist soil and is easy to cultivate in home gardens.",
//     category: "Herb",
//     season: "All Year",
//     country: "Morocco",
//     price: 1.0,
//     quantity: 150,
//     image: "https://cdn.pixabay.com/photo/2020/03/05/16/43/mint-4904876_1280.jpg",
//   ),
//   PlantModel(
//     name: "Coriander",
//     description:
//         "Coriander, also known as cilantro, is a versatile herb with fresh leaves and aromatic seeds. It is essential in Indian, Middle Eastern, and Latin cuisines, adding a distinctive flavor to curries, soups, and salads.",
//     category: "Herb",
//     season: "All Year",
//     country: "Oman",
//     price: 1.5,
//     quantity: 140,
//     image: "https://cdn.pixabay.com/photo/2019/06/06/08/00/coriander-4255400_1280.jpg",
//   ),
//   PlantModel(
//     name: "Parsley",
//     description:
//         "Parsley is a leafy herb commonly used as a garnish and flavoring in countless dishes. Rich in vitamins and minerals, it contributes freshness and nutrition to Mediterranean and Middle Eastern cuisine.",
//     category: "Herb",
//     season: "All Year",
//     country: "Lebanon",
//     price: 1.0,
//     quantity: 160,
//     image: "https://cdn.pixabay.com/photo/2021/07/07/18/34/parsley-6395051_1280.jpg",
//   ),
// ];

// // 🥬 Vegetables
// final List<PlantModel> vegetables = [
//   PlantModel(
//     name: "Tomato",
//     description:
//         "Tomatoes are one of the most widely consumed vegetables, used in sauces, salads, and countless dishes worldwide. They are rich in vitamin C, antioxidants, and lycopene, making them both healthy and versatile in cooking.",
//     category: "Vegetable Plant",
//     season: "Summer",
//     country: "Italy",
//     price: 1.8,
//     quantity: 300,
//     image: "https://cdn.pixabay.com/photo/2019/03/18/07/25/beefsteak-tomato-4062505_1280.jpg",
//   ),
//   PlantModel(
//     name: "Cucumber",
//     description:
//         "Cucumbers are crisp, refreshing vegetables high in water content. They are commonly eaten raw in salads, pickled, or used for skincare treatments to reduce puffiness and hydrate the skin.",
//     category: "Vegetable Plant",
//     season: "Summer",
//     country: "Egypt",
//     price: 1.2,
//     quantity: 220,
//     image: "https://cdn.pixabay.com/photo/2015/07/17/13/44/cucumbers-849269_1280.jpg",
//   ),
//   PlantModel(
//     name: "Carrot",
//     description:
//         "Carrots are crunchy, sweet root vegetables rich in beta-carotene, vitamin A, and dietary fiber. They are eaten raw, cooked, or juiced, and are known to promote good vision and overall health.",
//     category: "Vegetable Plant",
//     season: "Winter",
//     country: "Germany",
//     price: 0.8,
//     quantity: 400,
//     image: "https://cdn.pixabay.com/photo/2016/07/29/12/50/vegetable-1553195_1280.jpg",
//   ),
//   PlantModel(
//     name: "Spinach",
//     description:
//         "Spinach is a nutrient-rich leafy green, packed with iron, calcium, and vitamins. It is consumed in salads, soups, and curries, and is well-known for boosting strength and energy.",
//     category: "Vegetable Plant",
//     season: "Winter",
//     country: "China",
//     price: 1.0,
//     quantity: 200,
//     image: "https://cdn.pixabay.com/photo/2017/04/09/21/35/spinach-2216967_1280.jpg",
//   ),
//   PlantModel(
//     name: "Pumpkin",
//     description:
//         "Pumpkins are large, orange vegetables famous for their use in pies, soups, and autumn decorations. Rich in vitamins, antioxidants, and fiber, they are highly valued for both nutrition and cultural significance.",
//     category: "Vegetable Plant",
//     season: "Autumn",
//     country: "USA",
//     price: 3.0,
//     quantity: 100,
//     image: "https://cdn.pixabay.com/photo/2014/09/10/22/35/pumpkins-441203_1280.jpg",
//   ),
// ];

// // 🍎 Fruits
// final List<PlantModel> fruitPlants = [
//   PlantModel(
//     name: "Mango Tree",
//     description:
//         "The mango tree produces one of the world’s most beloved tropical fruits. Mangoes are juicy, sweet, and full of vitamins, widely consumed fresh or used in juices, smoothies, and desserts.",
//     category: "Fruit Plant",
//     season: "Summer",
//     country: "India",
//     price: 25.0,
//     quantity: 20,
//     image: "https://cdn.pixabay.com/photo/2014/05/15/02/57/mango-344501_1280.jpg",
//   ),
//   PlantModel(
//     name: "Apple Tree",
//     description:
//         "Apple trees thrive in temperate regions and produce crisp fruits that range from sweet to tart. Apples are versatile, eaten fresh, baked, juiced, or used in countless recipes worldwide.",
//     category: "Fruit Plant",
//     season: "Autumn",
//     country: "USA",
//     price: 30.0,
//     quantity: 15,
//     image: "https://cdn.pixabay.com/photo/2019/03/14/21/15/apple-4055926_1280.jpg",
//   ),
//   PlantModel(
//     name: "Strawberry",
//     description:
//         "Strawberries are small, red fruits with a juicy and sweet-tart flavor. Popular in desserts, drinks, and jams, they are a favorite worldwide for their vibrant taste and aroma.",
//     category: "Fruit Plant",
//     season: "Spring",
//     country: "Spain",
//     price: 2.0,
//     quantity: 200,
//     image: "https://cdn.pixabay.com/photo/2016/08/07/18/35/strawberry-plant-1576825_1280.jpg",
//   ),
//   PlantModel(
//     name: "Lemon Tree",
//     description:
//         "Lemon trees produce tangy yellow fruits widely used for juice, flavoring, and natural remedies. Lemons are rich in vitamin C and have strong antibacterial and detoxifying properties.",
//     category: "Fruit Plant",
//     season: "All Year",
//     country: "Italy",
//     price: 18.0,
//     quantity: 25,
//     image: "https://cdn.pixabay.com/photo/2016/01/02/01/49/lemon-1117568_1280.jpg",
//   ),
//   PlantModel(
//     name: "Grapevine",
//     description:
//         "Grapevines are climbing plants producing clusters of grapes used for fresh eating, drying into raisins, or winemaking. They thrive in warm climates with proper support structures.",
//     category: "Fruit Plant",
//     season: "Summer",
//     country: "France",
//     price: 22.0,
//     quantity: 12,
//     image: "https://cdn.pixabay.com/photo/2018/09/10/13/56/wine-3667119_1280.jpg",
//   ),
// ];

// // 🪴 Indoor & Succulents
// final List<PlantModel> indoorSucculents = [
//   PlantModel(
//     name: "Aloe Vera",
//     description:
//         "Aloe vera is a succulent plant famous for its medicinal gel used in skincare and healing burns. It requires minimal watering and grows well in hot, dry climates.",
//     category: "Succulent",
//     season: "All Year",
//     country: "Oman",
//     price: 6.0,
//     quantity: 200,
//     image: "https://cdn.pixabay.com/photo/2010/12/07/08/aloe-vera-1045_1280.jpg",
//   ),
//   PlantModel(
//     name: "Cactus",
//     description:
//         "Cacti are desert plants adapted to survive with minimal water. Their unique shapes and spines make them popular decorative plants both indoors and outdoors.",
//     category: "Succulent",
//     season: "All Year",
//     country: "Mexico",
//     price: 7.0,
//     quantity: 70,
//     image: "https://cdn.pixabay.com/photo/2014/07/29/08/55/cactus-404362_1280.jpg",
//   ),
//   PlantModel(
//     name: "Snake Plant",
//     description:
//         "The snake plant, also called mother-in-law’s tongue, is a hardy indoor plant that improves air quality. It tolerates low light and irregular watering, making it ideal for beginners.",
//     category: "Indoor",
//     season: "All Year",
//     country: "West Africa",
//     price: 8.0,
//     quantity: 65,
//     image: "https://cdn.pixabay.com/photo/2022/08/14/12/12/sansevieria-7385720_1280.jpg",
//   ),
//   PlantModel(
//     name: "Fern",
//     description:
//         "Ferns are lush green plants that thrive in humid, shaded environments. Their elegant fronds make them a beautiful addition to indoor gardens and offices.",
//     category: "Indoor",
//     season: "All Year",
//     country: "Australia",
//     price: 5.0,
//     quantity: 100,
//     image: "https://cdn.pixabay.com/photo/2024/06/15/07/09/fern-fronds-8831122_1280.jpg",
//   ),
//   PlantModel(
//     name: "Sunflower",
//     description:
//         "Sunflowers are tall, radiant plants with large yellow blooms that follow the sun’s path across the sky. They symbolize happiness and are used for seeds and oil production.",
//     category: "Flowering",
//     season: "Summer",
//     country: "USA",
//     price: 2.5,
//     quantity: 120,
//     image: "https://cdn.pixabay.com/photo/2020/05/14/13/20/sunflower-5171348_1280.jpg",
//   ),
// ];

// // 🌳 Trees
// final List<PlantModel> trees = [
//   PlantModel(
//     name: "Olive Tree",
//     description:
//         "The olive tree is an ancient symbol of peace and longevity. It produces olives used for food and high-quality olive oil, making it both culturally and economically significant.",
//     category: "Tree",
//     season: "Autumn",
//     country: "Greece",
//     price: 35.0,
//     quantity: 18,
//     image: "https://cdn.pixabay.com/photo/2020/04/18/21/41/lilac-5061139_1280.jpg",
//   ),
//   PlantModel(
//     name: "Eucalyptus",
//     description:
//         "Eucalyptus trees are tall evergreens with aromatic leaves used in medicine, oils, and wood production. They are fast-growing and provide a fresh scent in their surroundings.",
//     category: "Tree",
//     season: "All Year",
//     country: "Australia",
//     price: 28.0,
//     quantity: 22,
//     image: "https://cdn.pixabay.com/photo/2018/03/30/11/03/eucalyptus-pulverulenta-3275084_1280.jpg",
//   ),
//   PlantModel(
//     name: "Palm Tree",
//     description:
//         "Palm trees are iconic tropical plants that produce dates or coconuts, vital for food and culture in many regions. They thrive in hot, arid climates and sandy soils.",
//     category: "Tree",
//     season: "All Year",
//     country: "UAE",
//     price: 50.0,
//     quantity: 10,
//     image: "https://cdn.pixabay.com/photo/2014/06/23/21/12/palm-375635_1280.jpg",
//   ),
//   PlantModel(
//     name: "Cherry Blossom",
//     description:
//         "Cherry blossom trees, known as sakura in Japan, bloom in spring with stunning pink and white flowers. They symbolize renewal, beauty, and the fleeting nature of life.",
//     category: "Tree",
//     season: "Spring",
//     country: "Japan",
//     price: 40.0,
//     quantity: 10,
//     image: "https://cdn.pixabay.com/photo/2018/01/05/22/18/japanese-cherry-trees-3063992_1280.jpg",
//   ),
// ];
