import 'package:croppy/src/src.dart';
import 'package:flutter/widgets.dart';

/// A mixin that provides resizing functionality to a
/// [BaseCroppableImageController].
mixin ResizeTransformation on BaseCroppableImageController {
  /// Returns `true` if the user is currently resizing the crop rect.
  bool get isResizing => _isResizing;
  bool _isResizing = false;

  /// Called when the user starts resizing the crop rect.
  @mustCallSuper
  void onResizeStart() {
    onTransformationStart();
    _isResizing = true;
  }

  @protected
  CroppableImageData onResizeImpl({
    required CroppableImageData data,
    required Offset offsetDelta,
    required ResizeDirection direction,
  }) {
    final scaledOffset = offsetDelta / viewportScale;
    final rect = data.cropRect;
    Rect newRect;
    const double minSpacing = 50.0; // Minimum spacing between sides

    switch (direction) {
      case ResizeDirection.toTop:
        newRect = Rect.fromLTRB(
          rect.left,
          rect.top - scaledOffset.dy,
          rect.right,
          rect.bottom,
        );
        if (newRect.height < minSpacing) {
          newRect = Rect.fromLTRB(
            rect.left,
            rect.bottom - minSpacing,
            rect.right,
            rect.bottom,
          );
        }
        break;
      case ResizeDirection.toBottom:
        newRect = Rect.fromLTRB(
          rect.left,
          rect.top,
          rect.right,
          rect.bottom - scaledOffset.dy,
        );
        if (newRect.height < minSpacing) {
          newRect = Rect.fromLTRB(
            rect.left,
            rect.top,
            rect.right,
            rect.top + minSpacing,
          );
        }
        break;
      case ResizeDirection.toLeft:
        newRect = Rect.fromLTRB(
          rect.left - scaledOffset.dx,
          rect.top,
          rect.right,
          rect.bottom,
        );
        if (newRect.width < minSpacing) {
          newRect = Rect.fromLTRB(
            rect.right - minSpacing,
            rect.top,
            rect.right,
            rect.bottom,
          );
        }
        break;
      case ResizeDirection.toRight:
        newRect = Rect.fromLTRB(
          rect.left,
          rect.top,
          rect.right - scaledOffset.dx,
          rect.bottom,
        );
        if (newRect.width < minSpacing) {
          newRect = Rect.fromLTRB(
            rect.left,
            rect.top,
            rect.left + minSpacing,
            rect.bottom,
          );
        }
        break;
      case ResizeDirection.toTopLeft:
        newRect = Rect.fromLTRB(
          rect.left - scaledOffset.dx,
          rect.top - scaledOffset.dy,
          rect.right,
          rect.bottom,
        );
        if (newRect.width < minSpacing) {
          newRect = Rect.fromLTRB(
            rect.right - minSpacing,
            rect.top - scaledOffset.dy,
            rect.right,
            rect.bottom,
          );
        }
        if (newRect.height < minSpacing) {
          newRect = Rect.fromLTRB(
            rect.left - scaledOffset.dx,
            rect.bottom - minSpacing,
            rect.right,
            rect.bottom,
          );
        }
        if (newRect.width < minSpacing || newRect.height < minSpacing) {
          newRect = Rect.fromLTRB(
            rect.right - minSpacing,
            rect.bottom - minSpacing,
            rect.right,
            rect.bottom,
          );
        }
        break;
      case ResizeDirection.toTopRight:
        newRect = Rect.fromLTRB(
          rect.left,
          rect.top - scaledOffset.dy,
          rect.right - scaledOffset.dx,
          rect.bottom,
        );
        if (newRect.width < minSpacing) {
          newRect = Rect.fromLTRB(
            rect.left,
            rect.top - scaledOffset.dy,
            rect.left + minSpacing,
            rect.bottom,
          );
        }
        if (newRect.height < minSpacing) {
          newRect = Rect.fromLTRB(
            rect.left,
            rect.bottom - minSpacing,
            rect.right - scaledOffset.dx,
            rect.bottom,
          );
        }
        if (newRect.width < minSpacing || newRect.height < minSpacing) {
          newRect = Rect.fromLTRB(
            rect.left,
            rect.bottom - minSpacing,
            rect.left + minSpacing,
            rect.bottom,
          );
        }
        break;
      case ResizeDirection.toBottomLeft:
        newRect = Rect.fromLTRB(
          rect.left - scaledOffset.dx,
          rect.top,
          rect.right,
          rect.bottom - scaledOffset.dy,
        );
        if (newRect.width < minSpacing) {
          newRect = Rect.fromLTRB(
            rect.right - minSpacing,
            rect.top,
            rect.right,
            rect.bottom - scaledOffset.dy,
          );
        }
        if (newRect.height < minSpacing) {
          newRect = Rect.fromLTRB(
            rect.left - scaledOffset.dx,
            rect.top,
            rect.right,
            rect.top + minSpacing,
          );
        }
        if (newRect.width < minSpacing || newRect.height < minSpacing) {
          newRect = Rect.fromLTRB(
            rect.right - minSpacing,
            rect.top,
            rect.right,
            rect.top + minSpacing,
          );
        }
        break;
      case ResizeDirection.toBottomRight:
        newRect = Rect.fromLTRB(
          rect.left,
          rect.top,
          rect.right - scaledOffset.dx,
          rect.bottom - scaledOffset.dy,
        );
        if (newRect.width < minSpacing) {
          newRect = Rect.fromLTRB(
            rect.left,
            rect.top,
            rect.left + minSpacing,
            rect.bottom - scaledOffset.dy,
          );
        }
        if (newRect.height < minSpacing) {
          newRect = Rect.fromLTRB(
            rect.left,
            rect.top,
            rect.right - scaledOffset.dx,
            rect.top + minSpacing,
          );
        }
        if (newRect.width < minSpacing || newRect.height < minSpacing) {
          newRect = Rect.fromLTRB(
            rect.left,
            rect.top,
            rect.left + minSpacing,
            rect.top + minSpacing,
          );
        }
        break;
    }

    return data.copyWithProperCropShape(
      cropShapeFn: cropShapeFn,
      cropRect: newRect,
    );
  }

  /// Called when the user is resizing the crop rect. This will update the
  /// [BaseCroppableImageController.data] and notify listeners.
  void onResize({
    required Offset offsetDelta,
    required ResizeDirection direction,
  }) {
    data = onResizeImpl(
      data: data,
      offsetDelta: offsetDelta,
      direction: direction,
    );

    onTransformation((offsetDelta, direction));
  }

  /// Called when the user ends resizing the crop rect.
  @mustCallSuper
  void onResizeEnd() {
    _isResizing = false;
    onTransformationEnd();
  }
}
