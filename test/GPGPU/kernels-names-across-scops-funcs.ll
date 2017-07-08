; RUN: opt %loadPolly -polly-process-unprofitable -polly-codegen-ppcg \
; RUN: -polly-acc-dump-kernel-ir -disable-output < %s | FileCheck -check-prefix=KERNEL %s

; REQUIRES: pollyacc

; KERNEL: define ptx_kernel void @FUNC_foo_SCOP_0_KERNEL_0(i8 addrspace(1)* %MemRef0, i32 %p_0) #0 {
; KERNER-NEXT: define ptx_kernel void @FUNC_foo_SCOP_1_KERNEL_0(i8 addrspace(1)* %MemRef0, i32 %p_0) #0 {
; KERNER-NEXT: define ptx_kernel void @FUNC_foo2_SCOP_0_KERNEL_0(i8 addrspace(1)* %MemRef0, i32 %p_0) #0 {

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

; Function Attrs: nounwind uwtable
define void @foo(i32, i32*) #0 {
  br label %3

; <label>:3:                                      ; preds = %2
  %4 = icmp sgt i32 %0, 0
  br i1 %4, label %5, label %15

; <label>:5:                                      ; preds = %3
  br label %6

; <label>:6:                                      ; preds = %5, %6
  %7 = phi i64 [ 0, %5 ], [ %11, %6 ]
  %8 = getelementptr inbounds i32, i32* %1, i64 %7
  %9 = load i32, i32* %8, align 4, !tbaa !2
  %10 = add nsw i32 %9, 1
  store i32 %10, i32* %8, align 4, !tbaa !2
  %11 = add nuw nsw i64 %7, 1
  %12 = zext i32 %0 to i64
  %13 = icmp ne i64 %11, %12
  br i1 %13, label %6, label %14

; <label>:14:                                     ; preds = %6
  br label %15

; <label>:15:                                     ; preds = %14, %3
  %16 = tail call i64 @clock() #3
  %17 = icmp eq i64 %16, 0
  br i1 %17, label %18, label %31

; <label>:18:                                     ; preds = %15
  %19 = icmp sgt i32 %0, 0
  br i1 %19, label %20, label %30

; <label>:20:                                     ; preds = %18
  br label %21

; <label>:21:                                     ; preds = %20, %21
  %22 = phi i64 [ 0, %20 ], [ %26, %21 ]
  %23 = getelementptr inbounds i32, i32* %1, i64 %22
  %24 = load i32, i32* %23, align 4, !tbaa !2
  %25 = add nsw i32 %24, 1
  store i32 %25, i32* %23, align 4, !tbaa !2
  %26 = add nuw nsw i64 %22, 1
  %27 = zext i32 %0 to i64
  %28 = icmp ne i64 %26, %27
  br i1 %28, label %21, label %29

; <label>:29:                                     ; preds = %21
  br label %30

; <label>:30:                                     ; preds = %29, %18
  br label %31

; <label>:31:                                     ; preds = %30, %15
  ret void
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #1

; Function Attrs: nounwind
declare i64 @clock() #2

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #1

; Function Attrs: nounwind uwtable
define void @foo2(i32, i32*) #0 {
  br label %3

; <label>:3:                                      ; preds = %2
  %4 = icmp sgt i32 %0, 0
  br i1 %4, label %5, label %15

; <label>:5:                                      ; preds = %3
  br label %6

; <label>:6:                                      ; preds = %5, %6
  %7 = phi i64 [ 0, %5 ], [ %11, %6 ]
  %8 = getelementptr inbounds i32, i32* %1, i64 %7
  %9 = load i32, i32* %8, align 4, !tbaa !2
  %10 = add nsw i32 %9, 1
  store i32 %10, i32* %8, align 4, !tbaa !2
  %11 = add nuw nsw i64 %7, 1
  %12 = zext i32 %0 to i64
  %13 = icmp ne i64 %11, %12
  br i1 %13, label %6, label %14

; <label>:14:                                     ; preds = %6
  br label %15

; <label>:15:                                     ; preds = %14, %3
  ret void
}

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind }
attributes #2 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 5.0.0 (http://llvm.org/git/clang 98cf823022d1d71065c71e9338226ebf8bfa36ba) (http://llvm.org/git/llvm.git 4efa61f12928015bad233274ffa2e60c918e9a10)"}
!2 = !{!3, !3, i64 0}
!3 = !{!"int", !4, i64 0}
!4 = !{!"omnipotent char", !5, i64 0}
!5 = !{!"Simple C/C++ TBAA"}
