# FAQs

### Can we use something other than Terraform for my infrastructure as code?

Yes by all means, just make sure to document this in the README that guides the user through and that you are comfortable explaining why you chose the tool.

### Do I have to use CircleCI for my CI pipelines?

No. By all means feel free to use another CI tool if you wish. Make sure to make notes around why you chose a particular tool.

### Are there any tools you recommend for drawing diagrams of architecture?

[Draw.io](https://draw.io) provides an AWS icon set as well as other tools.

[Cloudskew](https://www.cloudskew.com/) has a free tier for one diagram and includes AWS icons.

[AWS Icon set and Templates](https://aws.amazon.com/architecture/icons/) - AWS provide tools like icons and images for the services as well as a Powerpoint toolkit. This page also lists a number of diagramming tools.

### Does everything have to be deployed as containers?

No. It is worth using containers, orchestrated through Kubernetes in some form but you might feel that other deployment approaches are better suited for certain aspects of the service.

### The code bases don't seem to include Dockerfiles, why is that?

Unfortunately the development teams have not yet been testing with Docker so if you need to containerise the applications you will need to create the Dockerfiles.