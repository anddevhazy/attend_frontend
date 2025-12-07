import 'package:attend/features/auth/domain/entities/student_entity.dart';
import 'package:attend/features/auth/domain/repositories/auth_repository.dart';
import 'package:attend/features/auth/domain/usecases/student_signup_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

// This import was  generated using: flutter pub run build_runner build --delete-conflicting-outputs
import 'student_signup_usecase_test.mocks.dart';

// Generate mocks for AuthRepository
@GenerateMocks([AuthRepository])
void main() {
  late StudentSignupUsecase studentSignupUsecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    studentSignupUsecase = StudentSignupUsecase(repository: mockAuthRepository);
  });

  final tStudentEntity = StudentEntity(
    studentId: "1",
    email: "haywhy2946@gmail.com",
    password: 'foobar',
  );

  test('should create an account for the student', () async {
    // arrange
    when(
      mockAuthRepository.studentSignUp(any),
    ).thenAnswer((_) async => Right(unit));

    // act
    final result = await studentSignupUsecase(tStudentEntity);

    // assert
    expect(result, Right(unit));
    verify(mockAuthRepository.studentSignUp(tStudentEntity));
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
