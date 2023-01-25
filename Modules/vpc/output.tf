
output "vpc_id" {
    value = aws_vpc.vpc.id 
}
output "pubsubnet1_id" {
    value = aws_subnet.pub-subnet-1.id 
}
output "pubsubnet2_id" {
    value = aws_subnet.pub-subnet-2.id 
}
output "privsubnet1_id" {
    value = aws_subnet.priv-subnet-1.id 
}
output "privsubnet2_id" {
    value = aws_subnet.priv-subnet-2.id 
}
output "privsubnet3_id" {
    value = aws_subnet.priv-subnet-3.id 
}
output "privsubnet4_id" {
    value = aws_subnet.priv-subnet-4.id 
}
