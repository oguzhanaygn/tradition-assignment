apiVersion: v1
kind: Service
metadata:
  name: nginx-svc
  namespace: nginx-test
  labels:
    app: nginx
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-backend-protocol: http
    service.beta.kubernetes.io/aws-load-balancer-security-groups: "${loadBalancer_sg_id}"
spec:
  ports:
  - port: 80
    name: http
    protocol: TCP
    targetPort: 80
  selector:
    app: nginx
  type: LoadBalancer