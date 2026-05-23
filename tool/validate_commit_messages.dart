import 'dart:io';

const _allowedTypes = <String>[
  'build',
  'chore',
  'ci',
  'docs',
  'feat',
  'fix',
  'perf',
  'refactor',
  'revert',
  'style',
  'test',
];

final RegExp _headerPattern = RegExp(
  '^(${_allowedTypes.join('|')})(\\([a-z0-9][a-z0-9._/-]*\\))?(!)?: .+',
);

void main(List<String> args) async {
  final mode = _parseArgs(args);

  switch (mode) {
    case _MessageFileMode(:final messageFilePath):
      final messageFile = File(messageFilePath);
      if (!messageFile.existsSync()) {
        _fail('Commit message file not found: $messageFilePath');
      }

      final message = messageFile.readAsStringSync();
      final header = _extractHeader(message);
      final error = _validateHeader(header);

      if (error != null) {
        _fail(_buildSingleMessageError(header, error));
      }

      stdout.writeln('Commit message passed Conventional Commits validation.');

    case _CommitRangeMode(:final from, :final to):
      final commits = await _loadCommitRange(from: from, to: to);
      final failures = <String>[];

      for (final commit in commits) {
        final error = _validateHeader(commit.header);
        if (error != null) {
          failures.add('${commit.sha}: ${commit.header}\n  - $error');
        }
      }

      if (failures.isNotEmpty) {
        _fail(_buildRangeError(from: from, to: to, failures: failures));
      }

      stdout.writeln(
        'Validated ${commits.length} commit message(s) from $from to $to.',
      );

    case _LastCommitMode():
      final commit = await _loadLastCommit();
      final error = _validateHeader(commit.header);
      if (error != null) {
        _fail(_buildSingleCommitError(commit.sha, commit.header, error));
      }

      stdout.writeln('Validated last commit message: ${commit.sha}.');
  }
}

sealed class _ValidationMode {}

class _MessageFileMode extends _ValidationMode {
  _MessageFileMode(this.messageFilePath);

  final String messageFilePath;
}

class _CommitRangeMode extends _ValidationMode {
  _CommitRangeMode({required this.from, required this.to});

  final String from;
  final String to;
}

class _LastCommitMode extends _ValidationMode {}

_ValidationMode _parseArgs(List<String> args) {
  if (args.length == 2 && args.first == '--message-file') {
    return _MessageFileMode(args[1]);
  }

  if (args.length == 4 && args[0] == '--from' && args[2] == '--to') {
    return _CommitRangeMode(from: args[1], to: args[3]);
  }

  if (args.length == 1 && args.first == '--last') {
    return _LastCommitMode();
  }

  _fail(
    'Unsupported arguments. Use one of:\n'
    '  dart run tool/validate_commit_messages.dart --message-file <path>\n'
    '  dart run tool/validate_commit_messages.dart --from <base-sha> --to <head-sha>\n'
    '  dart run tool/validate_commit_messages.dart --last',
  );
}

String _extractHeader(String message) {
  for (final rawLine in message.split('\n')) {
    final line = rawLine.trim();
    if (line.isEmpty || line.startsWith('#')) {
      continue;
    }
    return line;
  }

  return '';
}

String? _validateHeader(String header) {
  if (header.isEmpty) {
    return 'Commit message header is empty.';
  }

  if (_shouldIgnoreHeader(header)) {
    return null;
  }

  if (!_headerPattern.hasMatch(header)) {
    return 'Expected Conventional Commits format: '
        '<type>(optional-scope): short imperative summary';
  }

  return null;
}

bool _shouldIgnoreHeader(String header) {
  return header.startsWith('Merge ') ||
      header.startsWith('fixup! ') ||
      header.startsWith('squash! ') ||
      header.startsWith('Revert "');
}

Future<List<_CommitMessage>> _loadCommitRange({
  required String from,
  required String to,
}) async {
  final result = await Process.run('git', [
    'log',
    '--format=%H%x1f%s%x1e',
    '$from..$to',
  ], workingDirectory: Directory.current.path);

  if (result.exitCode != 0) {
    _fail('Failed to read commit range $from..$to:\n${result.stderr}');
  }

  final output = (result.stdout as String).trim();
  if (output.isEmpty) {
    return <_CommitMessage>[];
  }

  return output.split('').where((entry) => entry.trim().isNotEmpty).map((
    entry,
  ) {
    final fields = entry.split('');
    return _CommitMessage(
      sha: fields.first.trim(),
      header: fields.length > 1 ? fields[1].trim() : '',
    );
  }).toList();
}

Future<_CommitMessage> _loadLastCommit() async {
  final result = await Process.run('git', [
    'log',
    '-1',
    '--format=%H%x1f%s',
  ], workingDirectory: Directory.current.path);

  if (result.exitCode != 0) {
    _fail('Failed to read last commit message:\n${result.stderr}');
  }

  final output = (result.stdout as String).trim();
  if (output.isEmpty) {
    _fail('No commits found to validate.');
  }

  final fields = output.split('');
  return _CommitMessage(
    sha: fields.first.trim(),
    header: fields.length > 1 ? fields[1].trim() : '',
  );
}

String _buildSingleMessageError(String header, String error) {
  return 'Invalid commit message header: ${header.isEmpty ? '<empty>' : header}\n'
      '$error\n\n'
      'Allowed types: ${_allowedTypes.join(', ')}\n'
      'Examples: see tool/commit_message_examples.txt';
}

String _buildSingleCommitError(String sha, String header, String error) {
  return 'Commit $sha failed Conventional Commits validation.\n'
      'Header: ${header.isEmpty ? '<empty>' : header}\n'
      '$error\n\n'
      'Examples: see tool/commit_message_examples.txt';
}

String _buildRangeError({
  required String from,
  required String to,
  required List<String> failures,
}) {
  return 'Commit range $from..$to failed Conventional Commits validation.\n\n'
      '${failures.join('\n\n')}\n\n'
      'Examples: see tool/commit_message_examples.txt';
}

Never _fail(String message) {
  stderr.writeln(message);
  exit(1);
}

class _CommitMessage {
  const _CommitMessage({required this.sha, required this.header});

  final String sha;
  final String header;
}
