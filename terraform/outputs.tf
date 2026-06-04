output "public_ip" {
	description	= "Public IP of the Minecraft server"
	value		= aws_instance.minecraft.public_ip
}
