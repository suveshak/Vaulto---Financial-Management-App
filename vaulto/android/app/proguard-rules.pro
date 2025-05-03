# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# ML Kit
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.** { *; }

# Keep model classes
-keep class * extends com.google.mlkit.common.model.DownloadConditions { *; }
-keep class * extends com.google.mlkit.common.model.RemoteModelManager { *; }

# Keep the model downloader
-keep class com.google.mlkit.common.sdkinternal.ModelResource { *; }
-keep class com.google.mlkit.common.sdkinternal.model.* { *; }

# Keep the text recognition classes
-keep class com.google.mlkit.vision.text.** { *; }
-keep class com.google.mlkit.vision.common.** { *; }

# Keep the barcode scanning classes
-keep class com.google.mlkit.vision.barcode.** { *; }

# Keep the face detection classes
-keep class com.google.mlkit.vision.face.** { *; }

# Keep the image labeling classes
-keep class com.google.mlkit.vision.label.** { *; }

# Keep the object detection classes
-keep class com.google.mlkit.vision.objects.** { *; }

# Keep the pose detection classes
-keep class com.google.mlkit.vision.pose.** { *; }

# Keep the segmentation classes
-keep class com.google.mlkit.vision.segmentation.** { *; }

# Keep the common classes
-keep class com.google.mlkit.common.** { *; }
-keep class com.google.mlkit.samples.** { *; }

# AndroidX
-keep class androidx.** { *; }
-keep interface androidx.** { *; }

# Keep AndroidX AppCompat
-keep class androidx.appcompat.** { *; }
-keep interface androidx.appcompat.** { *; } 