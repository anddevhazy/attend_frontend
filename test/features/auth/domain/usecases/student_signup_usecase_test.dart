import 'package:attend/features/auth/domain/entities/student_entity.dart';
import 'package:attend/features/auth/domain/repositories/auth_repository.dart';
import 'package:attend/features/auth/domain/usecases/student_signup_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  StudentSignupUsecase studentSignupUsecase;
  MockAuthRepository mockAuthRepository;

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
      mockAuthRepository.studentSignupUsecase(any),
    ).thenAnswer((_) async => Right(tNumberTrivia));
    // act
    final result = await studentSignupUsecase(Params(number: tNumber));
    // assert
    expect(result, Right(tNumberTrivia));
    verify(mockAuthRepository.getConcreteNumberTrivia(tNumber));
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
