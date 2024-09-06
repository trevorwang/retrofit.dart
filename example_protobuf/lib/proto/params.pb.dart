//
//  Generated code. Do not modify.
//  source: proto/params.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Params extends $pb.GeneratedMessage {
  factory Params({
    $core.String? key,
  }) {
    final $result = create();
    if (key != null) {
      $result.key = key;
    }
    return $result;
  }

  Params._() : super();

  factory Params.fromBuffer(
    $core.List<$core.int> i, [
    $pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromBuffer(i, r);

  factory Params.fromJson(
    $core.String i, [
    $pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY,
  ]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
    _omitMessageNames ? '' : 'Params',
    package: const $pb.PackageName(
      _omitMessageNames ? '' : 'examples.enumerations',
    ),
    createEmptyInstance: create,
  )
    ..aOS(1, _omitFieldNames ? '' : 'key')
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Params clone() => Params()..mergeFromMessage(this);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Params copyWith(void Function(Params) updates) =>
      super.copyWith((message) => updates(message as Params)) as Params;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Params create() => Params._();

  Params createEmptyInstance() => create();

  static $pb.PbList<Params> createRepeated() => $pb.PbList<Params>();

  @$core.pragma('dart2js:noInline')
  static Params getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Params>(create);
  static Params? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);

  @$pb.TagNumber(1)
  set key($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);

  @$pb.TagNumber(1)
  void clearKey() => clearField(1);
}

const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
